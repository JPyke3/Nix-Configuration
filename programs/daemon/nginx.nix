{
  config,
  lib,
  ...
}: {
  services.nginx.virtualHosts."localhost" = {
    forceSSL = true;
    sslCertificate = /mypool/documents/Tailscale-Certs/jacob-china.tail264a8.ts.net.crt;
    sslCertificateKey = /mypool/documents/Tailscale-Certs/jacob-china.tail264a8.ts.net.key;
    locations = {
      "^~ /.well-known" = lib.mkForce {
        priority = 9000;
        extraConfig = ''
          absolute_redirect off;
          location ~ ^/\\.well-known/(?:carddav|caldav)$ {
            return 301 /nextcloud/remote.php/dav;
          }
          location ~ ^/\\.well-known/host-meta(?:\\.json)?$ {
            return 301 /nextcloud/public.php?service=host-meta-json;
          }
          location ~ ^/\\.well-known/(?!acme-challenge|pki-validation) {
            return 301 /nextcloud/index.php$request_uri;
          }
          try_files $uri $uri/ =404;
        '';
      };
      "/nextcloud/" = {
        priority = 9999;
        extraConfig = ''
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-NginX-Proxy true;
          proxy_set_header X-Forwarded-Proto http;
          proxy_pass http://127.0.0.1:8080/; # tailing / is important!
          proxy_set_header Host $host;
          proxy_cache_bypass $http_upgrade;
          proxy_redirect off;
        '';
      };
      "/firefly/" = {
        priority = 9998;
        root = "${config.services.firefly-iii.package}/public";
        tryFiles = "$uri $uri/ /index.php?$query_string";
        index = "index.php";
        extraConfig = ''
          sendfile off;
        '';
      };
      "~ (^/videoplayback|^/vi/|^/ggpht/|^/sb/)" = {
        proxyPass = "http://unix:/run/http3-ytproxy/socket/http-proxy.sock";
      };
      "/invidious" = {
        priority = 9998;
        proxyPass = "http://127.0.0.1:4664";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-Prefix /invidious;

          # Handle redirects
          proxy_redirect ~^/(.*)$ /invidious/$1;
        '';
      };
      "~ \.php$" = {
        extraConfig = ''
          include ${config.services.nginx.package}/conf/fastcgi_params ;
          fastcgi_param SCRIPT_FILENAME $request_filename;
          fastcgi_param modHeadersAvailable true; #Avoid sending the security headers twice
          fastcgi_pass unix:${config.services.phpfpm.pools.firefly-iii.socket};
        '';
      };
    };
  };
}
