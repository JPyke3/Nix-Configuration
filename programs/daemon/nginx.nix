{
  config,
  pkgs,
  ...
}: let
  domain = "pyk.ee";
  tailscaleDomain = "jacob-china.tail264a8.ts.net"; # Replace with your actual Tailscale domain
in {
  services.caddy = {
    enable = true;
    virtualHosts = {
      "nextcloud.${domain}" = {
        extraConfig = ''
          reverse_proxy localhost:8080
        '';
      };
      "invidious.${domain}" = {
        extraConfig = ''
          reverse_proxy localhost:3000
        '';
      };
    };
  };

  # Ensure Caddy uses Pi-hole for DNS resolution
  systemd.services.caddy.environment = {
    "DNS_SERVER" = "127.0.0.1";
  };

  networking = {
    # Use Pi-hole as the primary DNS server
    nameservers = ["127.0.0.1"];
    # Disable DHCP's DNS server propagation
    dhcpcd.extraConfig = "nohook resolv.conf";
    # Prevent NetworkManager from overwriting resolv.conf
    networkmanager.dns = "none";
  };

  networking.firewall = {
    allowedTCPPorts = [80 443];
    checkReversePath = "loose"; # Recommended for Tailscale
  };
}
