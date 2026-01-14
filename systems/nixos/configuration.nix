#nix-shell -p linuxPackages.nvidia_x11 Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  imports = [
    inputs.sops-nix.nixosModules.sops
    ../../programs/daemon/tailscale.nix
    ../../programs/daemon/syncthing/syncthing.nix
    ./unstable-packages.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  networking.nameservers = ["1.1.1.1" "1.0.0.1"]; # Cloudflare DNS
  networking.networkmanager.dns = "none";
  networking.dhcpcd.extraConfig = "nohook resolv.conf";

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  nix.settings.trusted-users = [
    "root"
    "jacobpyke"
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.users.users.jacobpyke.home}/.config/sops/age/keys.txt";
    secrets."users/jacobpyke/password".neededForUsers = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = ["en_US.UTF-8/UTF-8" "en_AU.UTF-8/UTF-8"];
  i18n.extraLocaleSettings = {
    LC_ALL = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Zelda Decomp
    xorg.libICE
    xorg.libX11
    xorg.libSM
    xorg.libXext
    xorg.libXrandr
    freetype
    libgccjit
    SDL2
    gtk3
    pango
    at-spi2-atk
    cairo
    gdk-pixbuf
    glib
    zlib
  ];

  fonts = {
    packages = with pkgs; [
      open-sans
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];

    fontDir.enable = true;
    fontconfig = {
      antialias = true;
      enable = true;
      hinting.autohint = false;
      hinting.style = "full";
      defaultFonts = {
        sansSerif = ["Noto Sans CJK JP"];
        serif = ["Noto Serif"];
      };
    };
  };

  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.substituters = [
    "http://jacob-china:5000/main" # Self-hosted Attic cache (via Tailscale)
    "https://jpyke3.cachix.org/" # Cachix fallback
  ];
  nix.settings.trusted-substituters = [
    "http://jacob-china:5000/main"
    "https://jpyke3.cachix.org/"
  ];
  nix.settings.trusted-public-keys = [
    "main:cTGyR3LMgVRA9oIu0U65WPKezuI9zl4EAlVb6y6I2kk="
    "jpyke3.cachix.org-1:SkUkQoQ6WbhSs7SGsMZ22H/DyJ7VNpT4/BaEvTCEQZY="
  ];

  programs.zsh.enable = true;

  users.defaultUserShell = pkgs.zsh;

  users.users.jacobpyke = {
    isNormalUser = true;
    home = "/home/jacobpyke";
    extraGroups = ["wheel" "networkmanager"];
    packages = with pkgs; [
      tree
    ];
    hashedPasswordFile = config.sops.secrets."users/jacobpyke/password".path;
  };

  system.autoUpgrade = {
    enable = true;
    allowReboot = false;
    dates = "03:00";
    flake = "github:JPyke3/Nix-Configuration";
    persistent = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    wofi
    blueman
    htop
    alejandra
    parallel
    nom
    nvd
    # oterm  # Temporarily disabled - fastmcp build failure upstream
    nh
    attic-client
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  #  programs.gnupg.agent = {
  #    enable = true;
  #    enableSSHSupport = true;
  #  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "23.11"; # Did you read the comment?
}
