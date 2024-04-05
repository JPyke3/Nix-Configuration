{
  config,
  pkgs,
  ...
}: {
  services = {
    syncthing = {
      enable = true;
      user = "${builtins.getEnv "HOSTNAME"}";
      dataDir = "${config.users.users.jacobpyke.home}/data";
      configDir = "${config.users.users.jacobpyke.home}/.config/syncthing";
    };
  };
}
