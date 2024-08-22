{...}: {
  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "media-server";
  };
}
