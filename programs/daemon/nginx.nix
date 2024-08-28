{
  config,
  pkgs,
  ...
}: let
  domain = "pyk.ee";
  tailscaleDomain = "jacob-china.tail264a8.ts.net"; # Replace with your actual Tailscale domain
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
          ''"${domain}. IN A 127.0.0.1"''
          ''"*.${domain}. IN A 127.0.0.1"''
          ''"${tailscaleDomain}. IN A 127.0.0.1"''
        ];
      };
    };
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "nextcloud.${domain}" = {
        forceSSL = true;
        sslCertificate = "/var/lib/tailscale/certs/${tailscaleDomain}.crt";
        sslCertificateKey = "/var/lib/tailscale/certs/${tailscaleDomain}.key";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          proxyWebsockets = true;
        };
      };
      "invidious.${domain}" = {
        forceSSL = true;
        sslCertificate = "/var/lib/tailscale/certs/${tailscaleDomain}.crt";
        sslCertificateKey = "/var/lib/tailscale/certs/${tailscaleDomain}.key";
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
        };
      };
      "nextcloud.${tailscaleDomain}" = {
        forceSSL = true;
        sslCertificate = "/var/lib/tailscale/certs/${tailscaleDomain}.crt";
        sslCertificateKey = "/var/lib/tailscale/certs/${tailscaleDomain}.key";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          proxyWebsockets = true;
        };
      };
      "invidious.${tailscaleDomain}" = {
        forceSSL = true;
        sslCertificate = "/var/lib/tailscale/certs/${tailscaleDomain}.crt";
        sslCertificateKey = "/var/lib/tailscale/certs/${tailscaleDomain}.key";
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
        };
      };
    };
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
  };

  networking.firewall = {
    allowedTCPPorts = [80 443 53];
    allowedUDPPorts = [53];
    checkReversePath = "loose"; # Recommended for Tailscale
  };

  systemd.services.tailscale-cert = {
    description = "Tailscale Certificate Renewal";
    wants = ["tailscaled.service"];
    after = ["tailscaled.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeScript "tailscale-cert-renew" ''
        #!${pkgs.bash}/bin/bash
        ${pkgs.tailscale}/bin/tailscale cert \
          --cert-file=/var/lib/tailscale/certs/${tailscaleDomain}.crt \
          --key-file=/var/lib/tailscale/certs/${tailscaleDomain}.key \
          ${tailscaleDomain}
        chown root:nginx /var/lib/tailscale/certs/${tailscaleDomain}.{crt,key}
        chmod 640 /var/lib/tailscale/certs/${tailscaleDomain}.{crt,key}
      '';
    };
  };

  systemd.timers.tailscale-cert = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "24h";
      Unit = "tailscale-cert.service";
    };
  };

  # Ensure the certificate directory exists and has correct permissions
  system.activationScripts = {
    tailscale-cert-dir = ''
      mkdir -p /var/lib/tailscale/certs
      chown -R root:nginx /var/lib/tailscale/certs
      chmod -R 750 /var/lib/tailscale/certs
    '';
  };

  # Ensure Nginx can read the Tailscale state directory
  systemd.services.nginx.serviceConfig.SupplementaryGroups = ["tailscale"];
}
