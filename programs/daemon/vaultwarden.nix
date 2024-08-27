{ config, sops, ... }:
{
  sops.secrets."programs/vaultwarden/envfile" = {};
	services.vaultwarden = {
		enable = true;
		backupDir = "/mypool/documents/vaultwarden/backup";
		environmentFile = config.sops.secrets."programs/vaultwarden/envfile".path;
	};
}
