{
  sops,
  config,
  ...
}: {
  sops.secrets."programs/invidious/password" = {};

  services.invidious = {
    enable = true;
    port = 4664;
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
