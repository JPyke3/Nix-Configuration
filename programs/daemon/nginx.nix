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
      "nextcloud.${domain}" = {
        forceSSL = true;
        useACMEHost = "${domain}";

        # Increase max upload size
        extraConfig = ''
          client_max_body_size 512M;
        '';

        locations = {
          "/" = {
            extraConfig = ''
              add_header Strict-Transport-Security "max-age=15768000; includeSubDomains; preload;" always;
              # Set headers for Nextcloud
              add_header Referrer-Policy                   "no-referrer"       always;
              add_header X-Content-Type-Options            "nosniff"           always;
              add_header X-Frame-Options                   "SAMEORIGIN"        always;
              add_header X-Permitted-Cross-Domain-Policies "none"              always;
              add_header X-Robots-Tag                      "noindex, nofollow" always;
              add_header X-XSS-Protection                  "1; mode=block"     always;

              # Remove X-Powered-By, which is an information leak
              fastcgi_hide_header X-Powered-By;

              # Path to the root of your Nextcloud installation
              root /var/lib/nextcloud;

              # Specify how to handle directories
              index index.php index.html /index.php$request_uri;

              # Rule borrowed from `.htaccess` to handle Microsoft DAV clients
              location = / {
                if ( $http_user_agent ~ ^DavClnt ) {
                  return 302 /remote.php/webdav/$is_args$args;
                }
              }

              location = /robots.txt {
                allow all;
                log_not_found off;
                access_log off;
              }

              # Make a regex exception for `/.well-known` so that clients can still
              # access it despite the existence of the regex rule
              location ^~ /.well-known {
                # The rules in this block are an adaptation of the rules
                # in `.htaccess` that concern `/.well-known`.

                location = /.well-known/carddav { return 301 /remote.php/dav/; }
                location = /.well-known/caldav  { return 301 /remote.php/dav/; }

                location /.well-known/acme-challenge    { try_files $uri $uri/ =404; }
                location /.well-known/pki-validation    { try_files $uri $uri/ =404; }

                # Let Nextcloud's API for `/.well-known` URIs handle all other
                # requests by passing them to the front-end controller.
                return 301 /index.php$request_uri;
              }

              # Rules borrowed from `.htaccess` to hide certain paths from clients
              location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)(?:$|/)  { return 404; }
              location ~ ^/(?:\.|autotest|occ|issue|indie|db_|console)                { return 404; }

              # Ensure this block, which passes PHP files to the PHP process, is above the blocks
              # which handle static assets (as seen below). If this block is not declared first,
              # then Nginx will encounter an infinite rewriting loop when it prepends `/index.php`
              # to the URI, resulting in a HTTP 500 error response.
              location ~ \.php(?:$|/) {
                # Required for legacy support
                rewrite ^/(?!index|remote|public|cron|core\/ajax\/update|status|ocs\/v[12]|updater\/.+|ocs-provider\/.+|.+\/richdocumentscode(_arm64)?\/proxy) /index.php$request_uri;

                fastcgi_split_path_info ^(.+?\.php)(/.*)$;
                set $path_info $fastcgi_path_info;

                try_files $fastcgi_script_name =404;

                include ${config.services.nginx.package}/conf/fastcgi_params;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                fastcgi_param PATH_INFO $path_info;
                fastcgi_param HTTPS on;

                fastcgi_param modHeadersAvailable true;         # Avoid sending the security headers twice
                fastcgi_param front_controller_active true;     # Enable pretty urls
                fastcgi_pass unix:/run/phpfpm/nextcloud.sock;

                fastcgi_intercept_errors on;
                fastcgi_request_buffering off;

                fastcgi_max_temp_file_size 0;
              }

              # Serve static files
              location ~ \.(?:css|js|mjs|svg|gif|ico|png|webp|woff|woff2|ttf|map)$ {
                try_files $uri /index.php$request_uri;
                add_header Cache-Control "public, max-age=15778463";
                access_log off;     # Optional: Don't log access to assets

                location ~ \.woff2?$ {
                  try_files $uri /index.php$request_uri;
                  expires 7d;
                  access_log off;
                }
              }

              location ~ /\.ht {
                deny all;
              }

              location ^~ /push {
                proxy_pass http://127.0.0.1:7867;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection "Upgrade";
                proxy_set_header Host $host;
                proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              }

              try_files $uri $uri/ /index.php$request_uri;
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
