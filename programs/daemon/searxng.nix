{sops, config, ...}: {
  sops.secrets."programs/searx/envfile" = {};
  services.searx = {
    enable = true;
	environmentFile = config.sops.secrets."programs/searx/envfile".path;
	settings = {
		server.port = 2082;
		server.bind_address = "0.0.0.0";
		server.secret_key = "@SEARX_SECRET_KEY@"
	};
  };
}
