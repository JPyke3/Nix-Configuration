{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.jovian.nixosModules.jovian
    ./syncthing.nix
  ];

  jovian.devices.steamdeck.enable = true;

  jovian.decky-loader = {
    enable = true;
    user = "jacobpyke";
  };

  jovian.steam = {
    enable = true;
    autoStart = true;
    desktopSession = "plasma";
    user = "jacobpyke";
  };

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

  services.xserver.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;

  services.pipewire.enable = true;
  services.printing.enable = true;

  environment.systemPackages = with pkgs; [
    amdgpu_top
  ];

  programs.steam = {
    enable = true;
    extest.enable = true;
    remotePlay.openFirewall = true;
  };
}
