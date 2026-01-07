{
  config,
  lib,
  ...
}: let
  domain = "pyk.ee";
in {
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "_" = {
        default = true;
        forceSSL = true;
        useACMEHost = "pyk.ee";
        locations."/" = {
          return = "444";
        };
      };
      "invidious.${domain}" = {
        forceSSL = true;
        enableACME = lib.mkForce false;
        useACMEHost = "${domain}";
      };
      "komga.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:26500";
        };
      };
      "unifi.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8443";
        };
      };
      "ha.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8123";
        };
      };
      "pihole.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:3080";
        };
      };
      "gitea.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
        };
      };
      "transmission.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:9091";
        };
      };
      "vaultwarden.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8000";
        };
      };
      "immich.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:3001";
        };
      };
      "firefly.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
      };
      "nextcloud.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
      };
      # Static file server for CI assets (Citrix tarball, etc.)
      # Using addSSL instead of forceSSL to allow HTTP access via Tailscale
      "files.${domain}" = {
        addSSL = true;
        useACMEHost = "${domain}";
        locations."/citrix/" = {
          alias = "/media/Software/citrix/";
          extraConfig = ''
            autoindex off;
            expires 30d;
          '';
        };
      };
    };
  };
}
