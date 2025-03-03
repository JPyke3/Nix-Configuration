{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.jovian.nixosModules.jovian
  ];

  jovian.devices.steamdeck.enable = true;

  jovian.steam = {
    enable = true;
    autoStart = true;
    desktopSession = "plasma";
    user = "jacobpyke";
  };

  networking.hostName = "jacob-switzerland"; # Define your hostname.
  networking.networkmanager.wifi.powersave = true;

  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.pipewire.enable = true;

  services.printing.enable = true;

  #  hardware.enable = {
  #    enable = true;
  #    driSupport = true;
  #    driSupport32Bit = true;
  #    extraPackages = with pkgs; [
  #      amdvlk
  #      driversi686Linux.amdvlk
  #    ];
  #  };

  environment.systemPackages = with pkgs; [
    amdgpu_top
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
}
