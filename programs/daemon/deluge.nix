{...}: {
  services.deluge = {
    enable = true;
    openFirewall = true;
    group = "media-server";
    web = {
      enable = true;
      openFirewall = true;
    };
    config = {
      allow_remote = true;
    };
  };
}
