{
  config,
  sops,
  ...
}: {
  sops.secrets."programs/vaultwarden/envfile" = {};
  services.vaultwarden = {
    enable = true;
    # backupDir = "/mypool/documents/vaultwarden/backup";
    environmentFile = config.sops.secrets."programs/vaultwarden/envfile".path;
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
    };
  };
}
