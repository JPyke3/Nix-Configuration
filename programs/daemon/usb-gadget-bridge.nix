# USB Gadget Network Bridge
#
# Enables internet sharing for USB gadget devices (like R36S, Raspberry Pi, etc.)
# when connected via USB Ethernet (RNDIS/CDC).
#
# How it works:
# 1. Device connects and NetworkManager auto-configures the interface
# 2. NAT masquerade rules (set at boot) forward traffic to the internet
# 3. Device gets internet access through the host
#
# Note: This assumes the USB device provides DHCP to assign IPs (like R36S does).
# If your device needs the host to provide DHCP, set enableDHCPServer = true.
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.jpyke3.usbGadgetBridge;
in {
  options.jpyke3.usbGadgetBridge = {
    enable = mkEnableOption "USB Gadget Network Bridge";

    subnet = mkOption {
      type = types.str;
      default = "10.1.1.0/30";
      description = "Subnet to NAT (must match your USB gadget's network)";
    };

    enableDHCPServer = mkOption {
      type = types.bool;
      default = false;
      description = "Enable DHCP server for devices that don't provide their own";
    };

    hostIP = mkOption {
      type = types.str;
      default = "10.1.1.1";
      description = "Host IP for DHCP server mode";
    };

    dhcpRange = mkOption {
      type = types.str;
      default = "10.1.1.2,10.1.1.2";
      description = "DHCP range (start,end) for DHCP server mode";
    };

    dnsServers = mkOption {
      type = types.listOf types.str;
      default = ["8.8.8.8" "8.8.4.4"];
      description = "DNS servers to provide via DHCP";
    };
  };

  config = mkIf cfg.enable {
    # Enable IP forwarding
    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

    # NAT rules - applied at boot, always ready for USB devices
    networking.firewall.extraCommands = ''
      # NAT masquerade for USB gadget subnet
      iptables -t nat -C POSTROUTING -s ${cfg.subnet} -j MASQUERADE 2>/dev/null || \
      iptables -t nat -A POSTROUTING -s ${cfg.subnet} -j MASQUERADE

      # Allow forwarding for the subnet
      iptables -C FORWARD -s ${cfg.subnet} -j ACCEPT 2>/dev/null || \
      iptables -A FORWARD -s ${cfg.subnet} -j ACCEPT

      iptables -C FORWARD -d ${cfg.subnet} -m state --state RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || \
      iptables -A FORWARD -d ${cfg.subnet} -m state --state RELATED,ESTABLISHED -j ACCEPT
    '';

    # Clean up rules on firewall reload
    networking.firewall.extraStopCommands = ''
      iptables -t nat -D POSTROUTING -s ${cfg.subnet} -j MASQUERADE 2>/dev/null || true
      iptables -D FORWARD -s ${cfg.subnet} -j ACCEPT 2>/dev/null || true
      iptables -D FORWARD -d ${cfg.subnet} -m state --state RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || true
    '';

    # Optional: DHCP server for devices that need it (disabled by default)
    # Triggered by udev when USB network device connects
    services.udev.extraRules = mkIf cfg.enableDHCPServer ''
      SUBSYSTEM=="net", ACTION=="add", DRIVERS=="rndis_host", TAG+="systemd", ENV{SYSTEMD_WANTS}="usb-gadget-dhcp@%k.service"
      SUBSYSTEM=="net", ACTION=="add", DRIVERS=="cdc_ether", TAG+="systemd", ENV{SYSTEMD_WANTS}="usb-gadget-dhcp@%k.service"
      SUBSYSTEM=="net", ACTION=="add", DRIVERS=="cdc_ncm", TAG+="systemd", ENV{SYSTEMD_WANTS}="usb-gadget-dhcp@%k.service"
      SUBSYSTEM=="net", ACTION=="add", DRIVERS=="cdc_ecm", TAG+="systemd", ENV{SYSTEMD_WANTS}="usb-gadget-dhcp@%k.service"
    '';

    systemd.services."usb-gadget-dhcp@" = mkIf cfg.enableDHCPServer {
      description = "USB Gadget DHCP Server for %i";
      after = ["network.target"];

      serviceConfig = {
        Type = "simple";
        ExecStartPre = "${pkgs.iproute2}/bin/ip addr add ${cfg.hostIP}/30 dev %i || true";
        ExecStart = ''
          ${pkgs.dnsmasq}/bin/dnsmasq \
            --interface=%i \
            --bind-interfaces \
            --dhcp-range=${cfg.dhcpRange},255.255.255.252,12h \
            --dhcp-option=option:router,${cfg.hostIP} \
            --dhcp-option=option:dns-server,${concatStringsSep "," cfg.dnsServers} \
            --no-daemon \
            --log-queries \
            --log-dhcp
        '';
        ExecStopPost = "${pkgs.iproute2}/bin/ip addr del ${cfg.hostIP}/30 dev %i || true";
        Restart = "on-failure";
      };
    };

    environment.systemPackages = mkIf cfg.enableDHCPServer [pkgs.dnsmasq];
  };
}
