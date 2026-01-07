{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../../programs/daemon/docker.nix
  ];

  networking.hostName = "jacob-norway";
  networking.networkmanager.wifi.powersave = false;

  # CachyOS optimized kernel
  nixpkgs.overlays = [inputs.nix-cachyos-kernel.overlays.pinned];
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

  # NVIDIA RTX 5070 Ti Mobile + AMD Radeon 890M (Hybrid Graphics)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      amdvlk
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  # NVIDIA Configuration
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = true; # Use open source kernel modules (required for RTX 50 series)
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta; # Beta for RTX 50 series support
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # Bus IDs from lspci (64:00.0 and 65:00.0)
      nvidiaBusId = "PCI:100:0:0"; # 64 hex = 100 decimal
      amdgpuBusId = "PCI:101:0:0"; # 65 hex = 101 decimal
    };
  };

  # ASUS ROG Laptop Tools
  services.asusd = {
    enable = true;
    enableUserService = true;
  };
  services.supergfxd.enable = true;

  # KDE Plasma 6 Desktop
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  # Hyprland (alternative WM)
  programs.hyprland = {
    enable = true;
  };

  # Audio (Pipewire)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Printing
  services.printing.enable = true;

  # Gaming
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  # Android Development
  programs.adb.enable = true;
  users.users.jacobpyke.extraGroups = ["adbusers" "video" "render"];

  # Waydroid for Android apps
  virtualisation.waydroid.enable = true;

  # Power management
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;

  # Firmware updates
  services.fwupd.enable = true;

  # System packages specific to this host
  environment.systemPackages = with pkgs; [
    # GPU tools
    nvtopPackages.full
    amdgpu_top
    vulkan-tools
    glxinfo

    # ASUS tools
    asusctl

    # Gaming
    mangohud
    gamescope
    lutris
    heroic

    # Desktop utilities
    kitty
    swaynotificationcenter
    swww
    waybar
    wl-clipboard

    # Development
    android-studio
  ];
}
