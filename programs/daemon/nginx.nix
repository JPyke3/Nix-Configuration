{
  config,
  pkgs,
  ...
}: let
  domain = "pyk.ee";
in {
  services.unbound = {
    enable = true;
    settings = {
      server = {
        interface = ["0.0.0.0"];
        access-control = [
          "127.0.0.0/8 allow"
          "100.64.0.0/10 allow" # Tailscale IP range
        ];
        local-data = [
          ''"nextcloud.${domain}. IN A 127.0.0.1"''
          ''"invidious.${domain}. IN A 127.0.0.1"''
          # Add more local-data entries for other subdomains
        ];
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "jacob@pyk.ee"; # Replace with your email
      dnsProvider = "route53";
      dnsPropagationCheck = true;
      dnsResolver = "1.1.1.1:53";
      credentialsFile = "/var/lib/acme/route53_credentials";
    };
  };

  services.nginx = {
    enable = true;
    # Recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "nextcloud.${domain}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080"; # Adjust port as needed
          proxyWebsockets = true;
        };
      };
      "invidious.${domain}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000"; # Adjust port as needed
        };
      };
      # Add more virtual hosts for other services
    };
  };

  services.tailscale.enable = true;

  networking.firewall = {
    allowedTCPPorts = [80 443 53];
    allowedUDPPorts = [53];
    checkReversePath = "loose"; # Recommended for Tailscale
  };

  # Ensure your system can resolve its own hostname
  networking.hosts = {
    "127.0.0.1" = ["nextcloud.${domain}" "invidious.${domain}"];
  };

  sops.secrets."acme/route53" = {
    path = "/var/lib/acme/route53_credentials";
  };
}
