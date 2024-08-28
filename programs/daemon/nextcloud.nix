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
      "nextcloud.pyk.ee"
    ];
    enable = true;
    hostName = "nextcloud.pyk.ee";
    config.adminpassFile = config.sops.secrets."programs/nextcloud/adminpass".path;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "nextcloud-27.1.11"
  ];
}
