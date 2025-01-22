{...}: {
  services.deluge = {
    enable = false;
    openFirewall = true;
    group = "media-server";
    web = {
      enable = true;
      openFirewall = true;
    };
  };
}
