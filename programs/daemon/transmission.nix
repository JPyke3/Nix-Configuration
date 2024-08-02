{...}: {
  services.transmission = {
    enable = true;
    group = "media-server";
    settings.download-dir = "/mypool/downloads";
  };
}
