{
  sops,
  config,
  ...
}: {
  sops.secrets."programs/nextcloud/adminpass" = {
    owner = "nextcloud";
  };

  services.nextcloud = {
    enable = true;
    home = "/mypool/documents/nextcloud";
    hostName = "jacob-china.tail264a8.ts.net";
    config.adminpassFile = config.sops.secrets."programs/nextcloud/adminpass".path;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "nextcloud-27.1.11"
  ];

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    listen = [
      {
        addr = "0.0.0.0";
        port = 41485;
      }
    ];
    forceSSL = true;
    sslCertificate = /mypool/documents/Tailscale-Certs/jacob-china.tail264a8.ts.net.crt;
    sslCertificateKey = /mypool/documents/Tailscale-Certs/jacob-china.tail264a8.ts.net.key;
  };
}
