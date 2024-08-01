{...}: {
  sops.secrets."programs/firefly/appKey" = {
    path = "${config.home.homeDirectory}/.secrets/firefly/appkey.txt";
  };
  services.firefly-iii = {
    enable = true;
    dataDir = "/mypool/documents/firefly-iii";
    user = "firefly";
    group = "firefly";
    settings = {
      APP_KEY_FILE = "${config.home.homeDirectory}/.secrets/firefly/appkey.txt";
    };
  };
}
