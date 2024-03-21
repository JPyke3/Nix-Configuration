{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.jovian.nixosModules.jovian
  ];

  boot.kernelPackages = pkgs.linuxPackages_jovian;

  jovian.devices.steamdeck.enable = true;

  jovian.steam = {
    enable = true;
    autoStart = true;
    desktopSession = "plasma";
    user = "jacobpyke";
  };

  networking.hostName = "jacob-japan"; # Define your hostname.
  #  networking.networkmanager.wifi.powersave = true;

  services.xserver.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;
  #  services.xserver.desktopManager.gnome.enable = true;

  services.pipewire.enable = true;

  services.printing.enable = true;

  environment.systemPackages = with pkgs; [
    amdgpu_top
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
}
