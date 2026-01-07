{config, ...}: {
  services.syncthing.settings.folders."Development" = {
    path = "/home/jacobpyke/data/Development";
    devices = ["norway" "germany"];
  };
}
