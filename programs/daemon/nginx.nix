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
      virtualHosts."nextcloud.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";

        extraConfig = ''
          client_max_body_size 512M;
        '';

        locations = {
          "/" = {
            priority = 1;
            extraConfig = ''
              add_header Strict-Transport-Security "max-age=15768000; includeSubDomains; preload;" always;
            '';
            headers = {
              "Referrer-Policy" = "no-referrer";
              "X-Content-Type-Options" = "nosniff";
              "X-Frame-Options" = "SAMEORIGIN";
              "X-Permitted-Cross-Domain-Policies" = "none";
              "X-Robots-Tag" = "noindex, nofollow";
              "X-XSS-Protection" = "1; mode=block";
            };
            root = "/var/lib/nextcloud";
            index = "index.php index.html /index.php$request_uri";
          };

          "= /" = {
            priority = 2;
            extraConfig = ''
              if ( $http_user_agent ~ ^DavClnt ) {
                return 302 /remote.php/webdav/$is_args$args;
              }
            '';
          };

          "= /robots.txt" = {
            priority = 3;
            extraConfig = ''
              allow all;
              log_not_found off;
              access_log off;
            '';
          };

          "^~ /.well-known" = {
            priority = 4;
            extraConfig = ''
              location = /.well-known/carddav { return 301 /remote.php/dav/; }
              location = /.well-known/caldav  { return 301 /remote.php/dav/; }
              location /.well-known/acme-challenge    { try_files $uri $uri/ =404; }
              location /.well-known/pki-validation    { try_files $uri $uri/ =404; }
              return 301 /index.php$request_uri;
            '';
          };

          "~ ^/(?:build|tests|config|lib|3rdparty|templates|data)(?:$|/)" = {
            priority = 5;
            return = "404";
          };

          "~ ^/(?:\.|autotest|occ|issue|indie|db_|console)" = {
            priority = 6;
            return = "404";
          };

          "~ \\.php(?:$|/)" = {
            priority = 7;
            extraConfig = ''
              fastcgi_split_path_info ^(.+?\.php)(/.*)$;
              set $path_info $fastcgi_path_info;
              try_files $fastcgi_script_name =404;
              include ${config.services.nginx.package}/conf/fastcgi_params;
              fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
              fastcgi_param PATH_INFO $path_info;
              fastcgi_param HTTPS on;
              fastcgi_param modHeadersAvailable true;
              fastcgi_param front_controller_active true;
              fastcgi_pass unix:/run/phpfpm/nextcloud.sock;
              fastcgi_intercept_errors on;
              fastcgi_request_buffering off;
              fastcgi_max_temp_file_size 0;
            '';
          };

          "~ \\.(?:css|js|mjs|svg|gif|ico|png|webp|woff|woff2|ttf|map)$" = {
            priority = 8;
            extraConfig = ''
              try_files $uri /index.php$request_uri;
              add_header Cache-Control "public, max-age=15778463";
              access_log off;
            '';
          };

          "~ /\\.ht" = {
            priority = 9;
            return = "404";
          };

          "^~ /push" = {
            priority = 10;
            proxyPass = "http://127.0.0.1:7867";
            extraConfig = ''
              proxy_http_version 1.1;
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "Upgrade";
              proxy_set_header Host $host;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            '';
          };
        };
      };
      "invidious.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:4664";
        };
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
    };
  };
}
