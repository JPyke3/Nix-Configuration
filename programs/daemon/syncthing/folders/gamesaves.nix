{...}: {
  services.syncthing.settings.folders."Game Saves" = {
    path = "/home/jacobpyke/data/Games/Saves";
    devices = ["norway" "japan" "germany" "korea" "italy"];
  };
}
