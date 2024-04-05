{
  config,
  pkgs,
  ...
}: {
  services = {
    syncthing = {
      enable = true;
      user = "${builtins.getEnv "HOSTNAME"}";
      dataDir = "${config.home.homeDirectory}/data";
      configDir = "${config.home.homeDirectory}/.config/syncthing";
    };
  };
}
