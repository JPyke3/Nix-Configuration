{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./syncthing.nix
    ../../../programs/daemon/altserver.nix
  ];

  networking.hostName = "jacob-singapore"; # Define your hostname.
  networking.networkmanager.wifi.powersave = false;

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;

  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
      driversi686Linux.amdvlk
    ];
  };

  environment.systemPackages = [
    pkgs.amdgpu_top
    config.nur.repos.ataraxiasjel.waydroid-script
  ];

  programs.hyprland = {
    enable = true;
  };
  services.xserver.desktopManager.plasma5.enable = true;

  virtualisation.waydroid.enable = true;

  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "03:00";
    flake = "github:JPyke3/Nix-Configuration";
    persistent = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
}
