{...}: {
  services.transmission = {
    enable = true;
    group = "media-server";
    openFirewall = true;
    settings.download-dir = "/mypool/downloads";
  };
}
