{
  config,
  lib,
  ...
}: {
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
          ''"nextcloud.pyk.ee. IN A 127.0.0.1"''
          ''"invidious.pyk.ee. IN A 127.0.0.1"''
          # Add more local-data entries for other subdomains
        ];
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "jacob@pyk.ee"; # Replace with your email
  };

  services.nginx = {
    enable = true;
    # Recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "nextcloud.pyk.ee" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080"; # Adjust port as needed
          proxyWebsockets = true;
        };
      };
    };
  };

  # Ensure your system can resolve its own hostname
  networking.hosts = {
    "127.0.0.1" = ["nextcloud.pyk.ee" "invidious.pyk.ee"];
  };
}
