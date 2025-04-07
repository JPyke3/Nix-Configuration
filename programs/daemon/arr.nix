{
  config,
  pkgs,
  ...
}: let
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
  services.sabnzbd = {
    enable = true;
    openFirewall = true;
  };
  # services.jackett = {
  #   enable = true;
  #   openFirewall = true;
  #   group = "media-server";
  # };
  services.deluge = {
    enable = true;
    openFirewall = true;
    group = "media-server";
    web = {
      enable = true;
      openFirewall = true;
    };
  };

  # Create the config directories if they don't exist
  systemd.tmpfiles.rules = [
    "d /var/lib/sonarr-tv/config 0770 jacobpyke users -"
    "d /var/lib/sonarr-4k/config 0770 jacobpyke users -"
    "d /var/lib/sonarr-german/config 0770 jacobpyke users -"
    "d /var/lib/sonarr-anime/config 0770 jacobpyke users -"
    "d /var/lib/radarr-movies/config 0770 jacobpyke users -"
    "d /var/lib/radarr-anime/config 0770 jacobpyke users -"
    "d /var/lib/recyclarr/config 0770 jacobpyke users -"
  ];

  # Containerised Services
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      sonarr-tv = {
        image = "linuxserver/sonarr";
        ports = ["3301:8989"];
        volumes = [
          "/var/lib/sonarr-tv/config:/config"
          "/media/TV Shows/Regular:/tv"
          "/media/Downloads:/downloads"
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";
        };
      };

      sonarr-anime = {
        image = "linuxserver/sonarr";
        ports = ["3302:8989"];
        volumes = [
          "/var/lib/sonarr-anime/config:/config"
          "/media/TV Shows/Anime:/tv"
          "/media/Downloads:/downloads"
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";
        };
      };

      recyclarr = {
        image = "ghcr.io/recyclarr/recyclarr";
        ports = ["3303:8989"];
        user = "1000:1000";
        volumes = [
          "/var/lib/recyclarr/config:/config"
        ];
        extraOptions = [
          "--network=host"
        ];
      };

      radarr-movies = {
        image = "linuxserver/radarr";
        ports = ["3304:7878"];
        volumes = [
          "/var/lib/radarr-movies/config:/config"
          "/media/Movies/Regular:/movies"
          "/media/Downloads:/downloads"
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";
        };
      };

      radarr-anime = {
        image = "linuxserver/radarr";
        ports = ["3305:7878"];
        volumes = [
          "/var/lib/radarr-anime/config:/config"
          "/media/Movies/Anime:/movies"
          "/media/Downloads:/downloads"
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";
        };
      };

      sonarr-4k = {
        image = "linuxserver/sonarr";
        ports = ["3306:8989"];
        volumes = [
          "/var/lib/sonarr-4k/config:/config"
          "/media/TV Shows/Regular:/tv"
          "/media/Downloads:/downloads"
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";
        };
      };
      sonarr-german = {
        image = "linuxserver/sonarr";
        ports = ["3308:8989"];
        volumes = [
          "/var/lib/sonarr-german/config:/config"
          "/media/TV Shows/German:/tv"
          "/media/Downloads:/downloads"
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
          proxyPass = "http://127.0.0.1:3301";
        };
      };
      "sonarr-anime.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:3302";
        };
      };
      "sonarr-4k.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:3306";
        };
      };
      "radarr-regular.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:3304";
        };
      };
      "radarr-anime.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:3305";
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
          proxyPass = "http://192.168.88.13:8096"; # Mac Mini
        };
      };
      "bazarr.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:6767";
        };
      };
      "sabnzbd.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:3307";
        };
      };
      "sonarr-german.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:3308";
        };
      };
    };
  };
}
