{ ...}: {
  services.syncthing.settings.folders."Development" = {
    path = "/home/jacobpyke/data/Development";
    devices = ["singapore" "netherlands" "germany"];
  };
}
