{...}: {
  services.syncthing.settings.folders."Game Firmware" = {
    path = "/home/jacobpyke/data/Games/Firmware";
    devices = ["norway" "germany" "japan" "korea" "italy"];
  };
}
