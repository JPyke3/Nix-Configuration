{...}: {
  services.radarr = {
    enable = true;
    openFirewall = true;
    group = "media-server";
  };
}
