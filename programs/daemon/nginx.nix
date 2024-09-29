{config, ...}: let
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
        useACMEHost = "${domain}";
      };
      "sonarr.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8989";
        };
      };
      "radarr.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:7878";
        };
      };
      "prowlarr.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:9696";
        };
      };
      "tdarr.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8265";
        };
      };
      "jellyseerr.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:5055";
        };
      };
      "jellyfin.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
        };
      };
      "searx.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:2082";
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
      "bazarr.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:6767";
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
    };
  };
}
