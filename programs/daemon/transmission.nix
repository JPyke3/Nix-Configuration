{config, ...}: {
  sops.secrets."programs/nord/wgConf" = {
    path = "${config.users.users.jacobpyke.home}/.secrets/nord/wg0.conf";
    owner = "jacobpyke";
  };

  vpnnamespaces.wg = {
    enable = true;
    wireguardConfigFile = /. + "${config.users.users.jacobpyke.home}/.secrets/nord/wg0.conf";
    accessibleFrom = [
      "192.168.1.0/24"
      "10.0.0.0/8"
      "127.0.0.1"
    ];
    portMappings = [
      {
        from = 9091;
        to = 9091;
      }
    ];
    openVPNPorts = [
      {
        port = 60729;
        protocol = "both";
      }
    ];
  };

  # Add systemd service to VPN network namespace.
  systemd.services.transmission.vpnconfinement = {
    enable = true;
    vpnnamespace = "wg";
  };

  services.transmission = {
    enable = true;
    group = "media-server";
    openFirewall = true;
    openRPCPort = true; #Open firewall for RPC
    settings = {
      #Override default settings
      rpc-bind-address = "192.168.15.5"; #Bind to own IP
      rpc-whitelist = "*.*.*.*";
      download-dir = "/mypool/downloads";
    };
  };
}
