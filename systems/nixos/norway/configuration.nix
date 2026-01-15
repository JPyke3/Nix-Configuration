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
  networking.networkmanager.wifi.backend = "iwd";

  # =============================================================================
  # SLEEP/SUSPEND FIX FOR ASUS G14 2025 (AMD HX 370 + RTX 5070 Ti)
  # =============================================================================
  # This laptop only supports s2idle (Modern Standby), not S3 deep sleep.
  # Multiple kernel parameters and services are required to make it work properly.

  boot.kernelParams = [
    # AMD Power Management - Critical for s2idle to reach deepest state
    # Note: enable_stb=1 not supported on G14 2025 firmware (causes probe failure)
    "amd_pmc.disable_workarounds=0" # Enable all PMC workarounds

    # ACPI fixes for Modern Standby
    "acpi.ec_no_wakeup=1" # Prevent EC from waking system
    "acpi_osi=Linux" # Better ACPI compatibility

    # AMD GPU - Disable VPE (Video Processing Engine) which crashes on suspend
    # Error: "VPE queue reset failed" and "IB test failed on vpe (-110)"
    # VPE is for hardware video encoding - not critical for normal use
    "amdgpu.vpe=0"

    # NVIDIA power management (RTX 50 series specific)
    # NVreg_PreserveVideoMemoryAllocations is already set by hardware.nvidia.powerManagement.enable
    "nvidia.NVreg_TemporaryFilePath=/var/tmp" # Temp storage for VRAM during suspend
    "nvidia_drm.fbdev=1" # Required for RTX 50 series framebuffer

    # USB wakeup prevention (common cause of immediate wake)
    # Remove this param once suspend is working if you want USB wake
    "usbcore.autosuspend=-1"
  ];

  # =============================================================================
  # WIFI SUSPEND FIX - MediaTek MT7925 has suspend bugs (error -110 timeout)
  # =============================================================================
  # Unload the WiFi driver before suspend, reload after resume
  powerManagement.powerDownCommands = ''
    ${pkgs.kmod}/bin/modprobe -r mt7925e mt792x_lib mt76_connac_lib mt76 || true
  '';
  powerManagement.resumeCommands = ''
    ${pkgs.kmod}/bin/modprobe mt7925e || true
  '';

  # NVIDIA suspend/resume/hibernate services are automatically created by
  # hardware.nvidia.powerManagement.enable = true (already set below)

  # Workaround for systemd freezing issues with NVIDIA proprietary drivers
  # See: https://github.com/NixOS/nixpkgs/issues/371058
  systemd.services.systemd-suspend.environment.SYSTEMD_SLEEP_FREEZE_USER_SESSIONS = "false";

  # Systemd sleep configuration
  # Note: SuspendMode/SuspendState/HibernateState removed in newer systemd
  # The system will use s2idle automatically since that's all the hardware supports
  systemd.sleep.extraConfig = ''
    # Allow suspend even without swap (hibernate won't work without disk swap)
    AllowSuspend=yes
    AllowHibernation=no
    AllowSuspendThenHibernate=no
    AllowHybridSleep=no
  '';

  # Disable nvidia-powerd on battery - it can prevent dGPU from suspending
  # See: https://asus-linux.org/faq/
  systemd.services.nvidia-powerd.enable = lib.mkForce false;

  # iwd for better wifi performance
  networking.wireless.iwd = {
    enable = true;
    settings = {
      Settings = {
        AutoConnect = true;
      };
    };
  };

  # Using default NixOS kernel (pre-built from binary cache)
  # CachyOS kernel available but requires compilation:
  # nixpkgs.overlays = [inputs.nix-cachyos-kernel.overlays.pinned];
  # boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;

  # NVIDIA RTX 5070 Ti Mobile + AMD Radeon 890M (Hybrid Graphics)
  # RADV (Mesa Vulkan) is enabled by default - amdvlk was deprecated
  hardware.graphics = {
    enable = true;
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

  # XDG Portal for screen sharing on Wayland
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-gtk # Required for GTK-based Flatpak apps
    ];
  };

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

  # KDE Connect (clipboard sharing, file transfer with phone)
  programs.kdeconnect.enable = true;

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

  # =============================================================================
  # OOM PREVENTION - earlyoom is more aggressive than systemd-oomd
  # =============================================================================
  # Prevents system freezes when memory-intensive tasks (like Gradle builds) run
  # earlyoom kills processes BEFORE the system becomes unresponsive
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5; # Kill when free RAM drops below 5%
    freeSwapThreshold = 10; # Kill when free swap drops below 10%
    enableNotifications = true; # Desktop notification when killing
    extraArgs = [
      "--prefer"
      "^(java|gradle|semgrep|node)$" # Prefer killing these heavy processes first
      "--avoid"
      "^(systemd|sddm|kwin|plasmashell|Hyprland)$" # Avoid killing system processes
    ];
  };

  # Firmware updates
  services.fwupd.enable = true;

  # Flatpak (for OpenBubbles and other apps not in nixpkgs)
  services.flatpak.enable = true;
  services.flatpak.update.onActivation = true;
  services.flatpak.remotes = [
    {
      name = "flathub";
      location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    }
  ];
  services.flatpak.packages = [
    "app.openbubbles.OpenBubbles"
  ];

  # System packages specific to this host
  environment.systemPackages = with pkgs; [
    # GPU tools
    nvtopPackages.full
    amdgpu_top
    vulkan-tools
    mesa-demos

    # ASUS tools
    asusctl

    # Gaming
    mangohud
    gamescope
    lutris
    heroic

    # Desktop utilities
    kitty
    swww
    waybar
    wl-clipboard
    kdePackages.kpipewire # Required for KDE Wayland screen sharing

    # Development
    android-studio
  ];
}
