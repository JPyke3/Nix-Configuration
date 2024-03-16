{...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-singapore"; # Define your hostname.
  networking.networkmanager.wifi.powersave = false;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;

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

  environment.systemPackages = with pkgs; [
    amdgpu_top
  ];

  programs.hyprland = {
    enable = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
}
