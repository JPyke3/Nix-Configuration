{
  config,
  pkgs,
  sops,
  ...
}: {
  services = {
    syncthing = {
      enable = true;
      user = "jacobpyke";
      dataDir = "/home/jacobpyke/data";
      configDir = "/home/jacobpyke/.config/syncthing";
    };
  };
}
