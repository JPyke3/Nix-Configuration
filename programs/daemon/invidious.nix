{
  sops,
  config,
  ...
}: {
  sops.secrets."programs/invidious/password" = {};

  services.invidious = {
    enable = true;
    port = 4664;
    database = {
      passwordFile = config.sops.secrets."programs/invidious/password".path;
    };
  };
}
