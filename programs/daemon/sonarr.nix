{...}: {
  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "media-server";
  };

  systemd.services.sonarr.serviceConfig = {
    UMask = "0002";
  };
}
