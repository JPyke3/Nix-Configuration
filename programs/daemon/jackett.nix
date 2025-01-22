{...}: {
  services.jackett = {
    enable = true;
    openFirewall = true;
    group = "media-server";
  };
}
