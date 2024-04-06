{
  config,
  pkgs,
  ...
}: {
  services = {
    syncthing = {
      enable = true;
      user = "${builtins.getEnv "HOSTNAME"}";
      dataDir = "/home/jacobpyke/data";
      configDir = "/home/jacobpyke/.config/syncthing";
    };
  };
}
