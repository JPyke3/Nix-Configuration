{...}: {
  services.syncthing.settings.folders."Game Roms" = {
    path = "/home/jacobpyke/data/Games/Roms";
    devices = ["norway" "germany" "japan"];
  };
}
