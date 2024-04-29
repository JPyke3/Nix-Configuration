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
      overrideFolders = true; # overrides any folders added or deleted through the WebUI -- Removed as this effectively breaks untrusted devices
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

          # iPad Mini
          "italy" = {
            id = "2FBCKZE-EB6KHXB-UFOGFQT-7WGVNJW-R4PVEMR-5U4QXSW-RVHKO6V-HZ2WUQ6";
            autoAcceptFolders = true;
          };

          # Steam Deck OLED
          "japan" = {id = "ULJ5XZI-BGAEGK6-LXGRBAA-LIZY5OK-SXGVZZT-6VIXHSW-SH2F5HR-ECT7CQ4";};

          # MacBook Pro
          "germany" = {id = "IBP7QMX-VLVOLK2-S4EUMDH-DP5OAGL-BZCG5PZ-U6CMSLD-LHKRYIA-3T4I4AO";};
        };
      };
    };
  };
}
