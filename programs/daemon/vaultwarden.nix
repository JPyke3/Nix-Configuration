{
  config,
  sops,
  ...
}: {
  sops.secrets."programs/vaultwarden/envfile" = {};
  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    backupDir = "/mypool/documents/vaultwarden/backup";
    environmentFile = config.sops.secrets."programs/vaultwarden/envfile".path;
  };
}
