{...}: {
  services.syncthing.settings.folders."Downloads" = {
    path = "/home/jacobpyke/data/Downloads";
    devices = ["singapore" "germany"];
  };
}
