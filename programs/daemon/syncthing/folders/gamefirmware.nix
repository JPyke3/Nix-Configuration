{...}: {
  services.syncthing.settings.folders."Game Firmware" = {
    path = "/home/jacobpyke/data/Games/Firmware";
    devices = ["singapore" "japan"];
  };
}
