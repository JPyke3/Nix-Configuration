{...}: {
  services.firefly-iii = {
    enable = true;
    dataDir = "/mypool/documents/firefly-iii";
    user = "firefly";
    group = "firefly";
  };
}
