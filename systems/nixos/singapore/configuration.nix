{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./syncthing.nix
    ../../../programs/daemon/altserver.nix
    ../../../programs/daemon/docker.nix
  ];

  networking.hostName = "jacob-singapore"; # Define your hostname.
  networking.networkmanager.wifi.powersave = false;

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;

  services.printing.enable = true;

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
    pkgs.alvr
    pkgs.corectrl
    config.nur.repos.ataraxiasjel.waydroid-script
  ];

  programs.hyprland = {
    enable = true;
  };

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

  programs.adb.enable = true;
  users.users.jacobpyke.extraGroups = ["adbusers"];

  services.udev.packages = [
    (
      pkgs.writeTextFile {
        name = "oculus-udev";
        text = ''
          SUBSYSTEM="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0186", MODE="0660" group="plugdev", symlink+="ocuquest%n"
        '';
        destination = "/lib/udev/rules.d/50-oculus.rules";
      }
    )
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
}
