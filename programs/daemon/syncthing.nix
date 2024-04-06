{
  config,
  pkgs,
  sops,
  ...
}: {
  sops.secrets."programs/syncthing/guipassword" = {};

  services = {
    syncthing = {
      enable = true;
      user = "jacobpyke";
      dataDir = "/home/jacobpyke/data";
      configDir = "/home/jacobpyke/.config/syncthing";
      overrideDevices = true; # overrides any devices added or deleted through the WebUI
      #      overrideFolders = true; # overrides any folders added or deleted through the WebUI -- Removed as this effectively breaks untrusted devices
      settings = {
        gui = {
          user = "jacobpyke";
          passwordFile = config.sops.secrets."programs/syncthing/guipassword".path;
        };
        devices = {
          # Desktop
          "singapore" = {id = "CNOEUAD-NAKEO7K-VFEOW3J-GYDKRJL-VQTCJDX-VHKDQUP-HHVIGNW-U5QY5AW";};

          # Seedbox
          "netherlands" = {
            addresses = [
              "tcp://merlion-direct.usbx.me:14568"
            ];
            id = "XQ4QCNY-G22ANRR-JBSR3SX-ODBHINE-OFS5NNF-IQQOAKW-KMSVRNA-OZLA5AQ";
            untrusted = true;
          };

          # iPhone
          "korea" = {
            id = "O44PLCJ-GQFQP2Z-WCQ5LWY-5AVPXQX-NV5CU3T-DYKD3D2-VVCZSZN-ORRTRQD";
            autoAcceptFolders = true;
          };
        };
        folders = {
          "Documents" = {
            path = "/home/jacobpyke/data/Documents";
            devices = ["singapore" "netherlands" "korea"];
          };
          "Downloads" = {
            path = "/home/jacobpyke/data/Downloads";
            devices = ["singapore" "korea"];
          };
          "Game Saves" = {
            path = "/home/jacobpyke/data/Games/Saves";
            devices = ["singapore" "korea"];
          };
          "Game Roms" = {
            path = "/home/jacobpyke/data/Games/Roms";
            devices = ["singapore"];
          };
          "Game Firmware" = {
            path = "/home/jacobpyke/data/Games/Firmware";
            devices = ["singapore"];
          };
        };
      };
    };
  };
}
