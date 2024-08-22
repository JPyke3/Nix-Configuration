{...}: {
  services.radarr = {
    enable = true;
    openFirewall = true;
    group = "media-server";
  };

  systemd.services.radarr.serviceConfig = {
    UMask = "0002";
  };
}
