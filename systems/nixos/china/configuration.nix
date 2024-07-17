# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../../programs/daemon/jellyfin.nix
    ../../../programs/daemon/jellyseerr.nix
    ../../../programs/daemon/sonarr.nix
    ../../../programs/daemon/radarr.nix
    ../../../programs/daemon/prowlarr.nix
    ../../../programs/daemon/lidarr.nix
    ../../../programs/daemon/deluge.nix
    ../../../programs/daemon/gitea.nix
    ../../../programs/daemon/searxng.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jacob-china"; # Define your hostname.
  networking.hostId = "5187cdf5";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # Configure keymap in X11
  services.xserver = {
    layout = "au";
    xkbVariant = "";
  };

  users.users.jacob = {
    isNormalUser = true;
    description = "Jacob Pyke";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  users.groups.git = {
    members = [
      "jacobpyke"
      "gitea"
    ];
  };

  users.groups.media-server = {
    members = [
      "sonarr"
      "radarr"
      "deluge"
      "lidarr"
      "jellyfin"
    ];
  };

  boot.supportedFilesystems = ["zfs"];
  boot.zfs.extraPools = ["mypool"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    zfs
    recyclarr
  ];
}
