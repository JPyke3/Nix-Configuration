{...}: {
  services.syncthing.settings.folders."Documents" = {
    path = "/home/jacobpyke/data/Documents";
    devices = ["singapore" "netherlands" "korea" "germany"];
  };
}
