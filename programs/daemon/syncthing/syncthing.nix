{config, ...}: {
  sops.secrets."programs/syncthing/guipassword" = {};

  services = {
    syncthing = {
      enable = true;
      user = "jacobpyke";
      dataDir = "/home/jacobpyke/data";
      configDir = "/home/jacobpyke/.config/syncthing";
      overrideDevices = true; # overrides any devices added or deleted through the WebUI
      settings = {
        gui = {
          user = "jacobpyke";
          passwordFile = config.sops.secrets."programs/syncthing/guipassword".path;
        };
        devices = {
          # Primary Laptop (ASUS ROG)
          "norway" = {id = "CNOEUAD-NAKEO7K-VFEOW3J-GYDKRJL-VQTCJDX-VHKDQUP-HHVIGNW-U5QY5AW";};

          # iPhone
          "korea" = {
            id = "O44PLCJ-GQFQP2Z-WCQ5LWY-5AVPXQX-NV5CU3T-DYKD3D2-VVCZSZN-ORRTRQD";
            autoAcceptFolders = true;
          };

          # iPad Mini
          "italy" = {
            id = "UDBRW67-QVOS2BW-UZ3VV6W-X4AAOUQ-5LPOPOF-UBGJVL5-T7BAOES-WGHTGQV";
            autoAcceptFolders = true;
          };

          # Steam Deck OLED
          "japan" = {id = "ULJ5XZI-BGAEGK6-LXGRBAA-LIZY5OK-SXGVZZT-6VIXHSW-SH2F5HR-ECT7CQ4";};

          # MacBook Pro
          "germany" = {id = "H233TH5-BV5EEES-ERKRY5R-WKMO53V-PIQRUEA-JJULILI-HOZBFWC-GJPKFQX";};
        };
      };
    };
  };
}
