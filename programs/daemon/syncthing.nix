{
  config,
  pkgs,
  networking,
  ...
}: {
  services = {
    syncthing = {
      enable = true;
      user = "${networking.hostName}";
      dataDir = "${config.home.homeDirectory}/data";
      configDir = "${config.home.homeDirectory}/.config/syncthing";
    };
  };
}
