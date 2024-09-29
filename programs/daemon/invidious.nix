{
  sops,
  config,
  ...
}: {
  sops.secrets."programs/invidious/password" = {};

  services.invidious = {
    enable = true;
    nginx.enable = true;
    port = 4664;
    domain = "invidious.pyk.ee";
    settings = {
      po_token = "MnTRqoG8F3o_e9GS4_4wv7WlvuZP0YDHf1RR6kHqikcBy1N4QfKa-c32_51yZMuaGN_Zs0eR8kHvMqQv0-UiGtifGM2fBEAnfHrvG08MbuOOJoV0FeNSPT9QiTVqr6TMLmQfuCygbePTr7tnsVXB3QjmKzVC4A==";
      visitor_data = "CgstWmhuWUx6dWhlQSjxxee3BjIKCgJBVRIEGgAgUg%3D%3D";
    };
    settings.db = {
      user = "invidious";
      dbname = "invidious";
    };
    database = {
      passwordFile = config.sops.secrets."programs/invidious/password".path;
    };
  };
}
