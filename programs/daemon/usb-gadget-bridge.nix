# USB Gadget Network Bridge
#
# Automatically bridges USB gadget devices (like R36S, Raspberry Pi, etc.) to the
# internet when connected. Provides DHCP so connected devices get auto-configured.
#
# How it works:
# 1. udev detects USB RNDIS/CDC Ethernet devices
# 2. Triggers a templated systemd service for that interface
# 3. Service configures IP, starts DHCP server, sets up NAT
# 4. Device gets IP via DHCP and can reach the internet
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.jpyke3.usbGadgetBridge;

  # Script to bring up the USB gadget bridge
  bridgeUpScript = pkgs.writeShellScript "usb-gadget-bridge-up" ''
    set -euo pipefail
    IFACE="$1"

    echo "USB Gadget Bridge: Configuring $IFACE"

    # Assign IP to the interface
    ${pkgs.iproute2}/bin/ip addr add ${cfg.hostIP}/${toString cfg.prefixLength} dev "$IFACE" 2>/dev/null || true
    ${pkgs.iproute2}/bin/ip link set "$IFACE" up

    # Add NAT masquerade rule if not already present
    ${pkgs.iptables}/bin/iptables -t nat -C POSTROUTING -s ${cfg.subnet} -j MASQUERADE 2>/dev/null || \
    ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${cfg.subnet} -j MASQUERADE

    # Allow forwarding from this interface
    ${pkgs.iptables}/bin/iptables -C FORWARD -i "$IFACE" -j ACCEPT 2>/dev/null || \
    ${pkgs.iptables}/bin/iptables -A FORWARD -i "$IFACE" -j ACCEPT

    ${pkgs.iptables}/bin/iptables -C FORWARD -o "$IFACE" -m state --state RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || \
    ${pkgs.iptables}/bin/iptables -A FORWARD -o "$IFACE" -m state --state RELATED,ESTABLISHED -j ACCEPT

    # Start DHCP server for this interface
    ${pkgs.dnsmasq}/bin/dnsmasq \
      --interface="$IFACE" \
      --bind-interfaces \
      --dhcp-range=${cfg.dhcpRangeStart},${cfg.dhcpRangeEnd},${cfg.netmask},12h \
      --dhcp-option=option:router,${cfg.hostIP} \
      --dhcp-option=option:dns-server,${concatStringsSep "," cfg.dnsServers} \
      --pid-file=/run/usb-gadget-dnsmasq-$IFACE.pid \
      --log-facility=/var/log/usb-gadget-dnsmasq-$IFACE.log \
      --keep-in-foreground &

    echo "USB Gadget Bridge: $IFACE configured successfully"
  '';

  # Script to tear down the USB gadget bridge
  bridgeDownScript = pkgs.writeShellScript "usb-gadget-bridge-down" ''
    set -euo pipefail
    IFACE="$1"

    echo "USB Gadget Bridge: Tearing down $IFACE"

    # Stop dnsmasq for this interface
    if [ -f "/run/usb-gadget-dnsmasq-$IFACE.pid" ]; then
      kill "$(cat /run/usb-gadget-dnsmasq-$IFACE.pid)" 2>/dev/null || true
      rm -f "/run/usb-gadget-dnsmasq-$IFACE.pid"
    fi

    # Remove IP from interface (interface may already be gone)
    ${pkgs.iproute2}/bin/ip addr del ${cfg.hostIP}/${toString cfg.prefixLength} dev "$IFACE" 2>/dev/null || true

    echo "USB Gadget Bridge: $IFACE torn down"
  '';
in {
  options.jpyke3.usbGadgetBridge = {
    enable = mkEnableOption "USB Gadget Network Bridge";

    hostIP = mkOption {
      type = types.str;
      default = "10.1.1.1";
      description = "IP address assigned to the host side of the USB interface";
    };

    prefixLength = mkOption {
      type = types.int;
      default = 30;
      description = "Network prefix length (30 = /30 subnet with 2 usable IPs)";
    };

    subnet = mkOption {
      type = types.str;
      default = "10.1.1.0/30";
      description = "Subnet for NAT rules";
    };

    netmask = mkOption {
      type = types.str;
      default = "255.255.255.252";
      description = "Netmask for DHCP";
    };

    dhcpRangeStart = mkOption {
      type = types.str;
      default = "10.1.1.2";
      description = "Start of DHCP range (usually the only other IP in a /30)";
    };

    dhcpRangeEnd = mkOption {
      type = types.str;
      default = "10.1.1.2";
      description = "End of DHCP range";
    };

    dnsServers = mkOption {
      type = types.listOf types.str;
      default = ["8.8.8.8" "8.8.4.4"];
      description = "DNS servers to provide via DHCP";
    };
  };

  config = mkIf cfg.enable {
    # Enable IP forwarding
    boot.kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
    };

    # udev rule to detect USB gadget network devices and trigger the bridge service
    # Matches common USB Ethernet gadget drivers: RNDIS (Windows compatible) and CDC Ethernet
    services.udev.extraRules = ''
      # USB RNDIS devices (Windows-compatible USB Ethernet)
      SUBSYSTEM=="net", ACTION=="add", DRIVERS=="rndis_host", TAG+="systemd", ENV{SYSTEMD_WANTS}="usb-gadget-bridge@%k.service"

      # USB CDC Ethernet devices (Linux native USB Ethernet)
      SUBSYSTEM=="net", ACTION=="add", DRIVERS=="cdc_ether", TAG+="systemd", ENV{SYSTEMD_WANTS}="usb-gadget-bridge@%k.service"

      # USB CDC NCM devices (USB Network Control Model)
      SUBSYSTEM=="net", ACTION=="add", DRIVERS=="cdc_ncm", TAG+="systemd", ENV{SYSTEMD_WANTS}="usb-gadget-bridge@%k.service"

      # USB CDC ECM devices (USB Ethernet Control Model)
      SUBSYSTEM=="net", ACTION=="add", DRIVERS=="cdc_ecm", TAG+="systemd", ENV{SYSTEMD_WANTS}="usb-gadget-bridge@%k.service"
    '';

    # Templated systemd service - %i gets replaced with the interface name
    systemd.services."usb-gadget-bridge@" = {
      description = "USB Gadget Network Bridge for %i";
      after = ["network.target"];

      serviceConfig = {
        Type = "forking";
        RemainAfterExit = true;
        ExecStart = "${bridgeUpScript} %i";
        ExecStop = "${bridgeDownScript} %i";
      };
    };

    # Ensure dnsmasq is available but don't run the global service
    # (we run per-interface instances instead)
    environment.systemPackages = [pkgs.dnsmasq];
  };
}
