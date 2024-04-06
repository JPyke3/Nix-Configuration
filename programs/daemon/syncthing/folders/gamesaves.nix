{...}: {
  services.syncthing.settings.folders."Game Saves" = {
    path = "/home/jacobpyke/data/Games/Saves";
    devices = ["singapore" "japan"];
  };
}
