{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.jovian.nixosModules.jovian
    ./syncthing.nix
  ];

  environment.systemPackages = with pkgs; [
    steamdeck-firmware
  ];

  jovian = {
    devices.steamdeck = {
      enable = true;
      enableGyroDsuService = true;
      autoUpdate = true;
    };

    decky-loader = {
      enable = true;
      user = "jacobpyke";
    };

    steam = {
      enable = true;
      autoStart = true;
      desktopSession = "plasma";
      user = "jacobpyke";
    };
  };

  services.desktopManager.plasma6.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    oxygen
  ];

  # Small Hack for the SD Card
  systemd.services.mount-games = {
    description = "Mount /dev/mmcblk0p1 to /games";
    wantedBy = ["multi-user.target"];
    after = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if [ -b /dev/mmcblk0p1 ]; then
        /run/current-system/sw/bin/mkdir -p /games
        /run/wrappers/bin/mount /dev/mmcblk0p1 /games
      fi
    '';
  };

  networking.hostName = "jacob-japan"; # Define your hostname.
  networking.networkmanager.wifi.powersave = true;

  services.xserver = {
    enable = true;
  };

  services.pipewire.enable = true;
  services.printing.enable = true;

  # programs.steam = {
  #   enable = true;
  #   extest.enable = true;
  #   remotePlay.openFirewall = true;
  # };
}
