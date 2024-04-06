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
          "singapore" = { id = "CNOEUAD-NAKEO7K-VFEOW3J-GYDKRJL-VQTCJDX-VHKDQUP-HHVIGNW-U5QY5AW"; };
		  "netherlands" = { id = "XQ4QCNY-G22ANRR-JBSR3SX-ODBHINE-OFS5NNF-IQQOAKW-KMSVRNA-OZLA5AQ"; };
        };
        folders = {
          "Documents" = {
            path = "/home/jacobpyke/data/Documents";
            devices = ["singapore"];
          };
		  "Downloads" = {
		  	path = "/home/jacobpyke/data/Downloads";
			devices = ["singapore", "netherlands"];
		  };
          "Game Saves" = {
            path = "/home/jacobpyke/data/Games/Saves";
            devices = ["singapore", "netherlands"];
          };
		  "Game Roms" = {
			path = "/home/jacobpyke/data/Games/Roms";
			devices = ["singapore", "netherlands"];
		  };
		  "Game Firmware" = {
			path = "/home/jacobpyke/data/Games/Firmware";
			devices = ["singapore", "netherlands"];
		  };
        };
      };
    };
  };
}
