{
  config,
  sops,
  ...
}: {
  sops.secrets."programs/vaultwarden/envfile" = {};
  security.acme.defaults.email = "jacob@pyk.ee"
  services.nginx.virtualHosts."vaultwarden.jacob-china.tail264a8.ts.net" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
    };
  };
  services.vaultwarden = {
    enable = true;
    # backupDir = "/mypool/documents/vaultwarden/backup";
    environmentFile = config.sops.secrets."programs/vaultwarden/envfile".path;
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
    };
  };
}
