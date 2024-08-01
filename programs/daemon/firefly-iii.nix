{config, ...}: {
  sops.secrets."programs/firefly/appKey" = {
    path = "/mypool/documents/firefly-iii/appkey.txt";
    owner = "firefly-iii";
  };

  services.firefly-iii = {
    enable = true;
    dataDir = "/mypool/documents/firefly-iii/data";
    settings = {
      APP_KEY_FILE = "/mypool/documents/firefly-iii/appkey.txt";
    };
  };
}
