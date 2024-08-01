{config, ...}: {
  sops.secrets."programs/firefly/appKey" = {
    path = "${config.users.users.jacobpyke.home}/.secrets/firefly/appkey.txt";
  };

  services.firefly-iii = {
    enable = true;
    dataDir = "/mypool/documents/firefly-iii";
    settings = {
      APP_KEY_FILE = "${config.users.users.jacobpyke.home}/.secrets/firefly/appkey.txt";
    };
  };
}
