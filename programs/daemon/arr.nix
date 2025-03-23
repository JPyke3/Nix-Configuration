{ config, pkgs, ... }:
let
	domain = "pyk.ee";
in {
  # NixOS Enabled Services
  services.bazarr = {
    enable = true;
    openFirewall = true;
    group = "media-server";
  };
  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };
  services.jackett = {
    enable = true;
    openFirewall = true;
    group = "media-server";
  };
  services.deluge = {
    enable = true;
    openFirewall = true;
    group = "media-server";
    web = {
      enable = true;
      openFirewall = true;
    };
  };

  # Containerised Services
   virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      sonarr-tv = {
        image = "linuxserver/sonarr";
        ports = [ "8989:3301" ];
        volumes = [
          "/var/lib/sonarr-tv/config:/config"
          "/media/TV Shows/Regular:/tv"
          "/Media/Downloads:/downloads"
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";
        };
      };

      sonarr-anime = {
        image = "linuxserver/sonarr";
        ports = [ "8989:3302" ];
        volumes = [
          "/var/lib/sonarr-anime/config:/config"
          "/media/TV Shows/Anime:/tv"
          "/Media/Downloads:/downloads"
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";
        };
      };

      recyclarr = {
        image = "ghcr.io/recyclarr/recyclarr";
        ports = [ "8989:3303" ];
        volumes = [
          "/var/lib/recyclarr/config:/config"
        ];
      };

      radarr-movies = {
        image = "linuxserver/radarr";
        ports = [ "7878:3304" ];
        volumes = [
          "/var/lib/radarr-movies/config:/config"
          "/media/Movies/Regular:/movies"
          "/Media/Downloads:/downloads"
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";
        };
      };

      radarr-anime = {
        image = "linuxserver/radarr";
        ports = [ "7879:3305" ];
        volumes = [
          "/var/lib/radarr-anime/config:/config"
          "/media/Movies/Anime:/movies"
          "/Media/Downloads:/downloads"
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";
        };
      };
    };
  };

  # Reverse Proxy
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
      "sonarr-regular.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:3001";
        };
      };
      "sonarr-anime.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:3002";
        };
      };
      "jackett.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:9117";
        };
      };
      "prowlarr.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:9696";
        };
      };
      "jellyfin.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://100.99.79.19:8096"; # Mac Mini via Tailscale
        };
      };
      "bazarr.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:6767";
        };
      };
    };
  };
}

