#nix-shell -p linuxPackages.nvidia_x11 Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  pkgs,
  inputs,
  config,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  imports = [
    inputs.sops-nix.nixosModules.sops
    ../../programs/daemon/tailscale.nix
    ../../programs/daemon/syncthing/syncthing.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.networkmanager.enable = true;
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

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      source-code-pro
      source-han-mono
      source-han-sans
      source-han-serif
      wqy_zenhei
    ];

    fontDir.enable = true;
    fontconfig = {
      antialias = true;
      enable = true;
    };
  };

  nix.settings.experimental-features = "nix-command flakes";

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    kitty
    wofi
    blueman
    htop
    alejandra
    parallel
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
