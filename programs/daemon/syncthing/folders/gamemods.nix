{...}: {
  services.syncthing.settings.folders."Game Mods" = {
    path = "/home/jacobpyke/data/Games/Mods";
    devices = ["norway" "germany" "japan"];
  };
}
