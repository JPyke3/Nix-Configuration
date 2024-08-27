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
      ROCKET_PORT = 8000;
	  ROCKET_TLS="{certs=\"/home/jacobpyke/jacob-china.tail264a8.ts.net.crt\",key=\"/home/jacobpyke/jacob-china.tail264a8.ts.net.key\"}"
    };
  };
}
