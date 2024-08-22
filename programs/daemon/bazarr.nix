{...}: {
  services.bazarr = {
    enable = true;
    openFirewall = true;
    group = "media-server";
  };
}
