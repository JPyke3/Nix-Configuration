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
    settings.trusted_domains = [
      "jacob-china.tail264a8.ts.net"
    ];
    enable = true;
    hostName = "nextcloud.pyk.ee";
    config.adminpassFile = config.sops.secrets."programs/nextcloud/adminpass".path;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "nextcloud-27.1.11"
  ];

  services.nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [
    {
      addr = "127.0.0.1";
      port = 8080; # NOT an exposed port
    }
  ];
}
