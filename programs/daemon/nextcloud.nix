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
      host = "127.0.0.1";
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
    hostName = "127.0.0.1";
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
