{
  sops,
  config,
  ...
}: {
  sops.secrets."programs/invidious/password" = {};

  # ervices.invidious.settings.db.user must match services.invidious.settings.db.dbname

  services.invidious = {
    enable = true;
    port = 4664;
    address = "127.0.0.1";
    http3-ytproxy.enable = true;
    settings.db = {
      user = "invidious";
      dbname = "invidious";
    };
    database = {
      passwordFile = config.sops.secrets."programs/invidious/password".path;
    };
  };
}
