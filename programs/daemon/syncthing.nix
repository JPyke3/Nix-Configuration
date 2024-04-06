{
  config,
  pkgs,
  sops,
  ...
}: {
  services = {
    syncthing = {
      enable = true;
      user = "jacobpyke";
      dataDir = "/home/jacobpyke/data";
      configDir = "/home/jacobpyke/.config/syncthing";
      overrideDevices = true; # overrides any devices added or deleted through the WebUI
      overrideFolders = true; # overrides any folders added or deleted through the WebUI
      settings = {
        devices = {
          "singapore" = {id = "CNOEUAD-NAKEO7K-VFEOW3J-GYDKRJL-VQTCJDX-VHKDQUP-HHVIGNW-U5QY5AW";};
        };
        folders = {
          "Documents" = {
            path = "/home/jacobpyke/data/Documents";
            devices = ["singapore"];
          };
          "Game Saves" = {
            path = "/home/jacobpyke/data/Games/Saves";
            devices = ["singapore"];
          };
        };
      };
    };
  };
}
