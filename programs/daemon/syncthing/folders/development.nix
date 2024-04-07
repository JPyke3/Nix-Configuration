{config, ...}: {
  home.folder."Development".source = config.lib.file.mkOutOfStoreSymlink "/home/jacobpyke/data/Development";
  services.syncthing.settings.folders."Development" = {
    path = "/home/jacobpyke/data/Development";
    devices = ["singapore" "netherlands" "korea" "germany"];
  };
}
