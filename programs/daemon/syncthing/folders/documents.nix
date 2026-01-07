{...}: {
  services.syncthing.settings.folders."Documents" = {
    path = "/home/jacobpyke/data/Documents";
    devices = ["norway" "korea" "germany" "italy"];
  };
}
