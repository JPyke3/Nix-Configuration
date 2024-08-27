{
  sops,
  config,
  lib,
  ...
}: {
  sops.secrets."programs/nextcloud/adminpass" = {
    owner = "nextcloud";
  };

  services.nextcloud = {
    settings = let
      prot = "https"; # or https
      host = "jacob-china.tail264a8.ts.net";
      dir = "/nextcloud";
    in {
      overwriteprotocol = prot;
      overwritehost = host;
      overwritewebroot = dir;
      overwrite.cli.url = "${prot}://${host}${dir}/";
      htaccess.RewriteBase = dir;
      trusted_domains = [
        "jacob-china.tail264a8.ts.net"
      ];
    };
    enable = true;
    hostName = "localhost";
    config.adminpassFile = config.sops.secrets."programs/nextcloud/adminpass".path;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "nextcloud-27.1.11"
  ];

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
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
    };
  };
}
