# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.vpnconfinement.nixosModules.default
    ./hardware-configuration.nix
    ../../../programs/daemon/sonarr.nix
    ../../../programs/daemon/radarr.nix
    ../../../programs/daemon/bazarr.nix
    ../../../programs/daemon/prowlarr.nix
    ../../../programs/daemon/lidarr.nix
    ../../../programs/daemon/deluge.nix
    ../../../programs/daemon/vaultwarden.nix
    ../../../programs/daemon/acme.nix
    ../../../programs/daemon/nginx.nix
    ../../../programs/daemon/matter.nix
    ../../../programs/daemon/stash.nix
    ../../../programs/daemon/mylar.nix
    #    ../../../programs/daemon/unifi.nix
  ];

  # jpyke3.scheduleReboot = {
  #   enable = true;
  #   hour = "03";
  # };

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
    xkb.layout = "au";
    xkb.variant = "";
  };

  users.users.jacob = {
    isNormalUser = true;
    description = "Jacob Pyke";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  users.groups.documents = {
    members = [
      "jacobpyke"
      "firefly"
      "vaultwarden"
      "nextcloud"
      "immich"
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
      "transmission"
      "jacobpyke"
      "bazarr"
      "immich"
    ];
  };

  # system.autoUpgrade = {
  #   enable = true;
  #   allowReboot = true;
  #   dates = "03:00";
  #   flake = "github:JPyke3/Nix-Configuration";
  #   persistent = true;
  # };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    recyclarr
  ];

  networking.firewall = {
    enable = true;

    # Allow incoming connections on these ports
    allowedTCPPorts = [
      22 # SSH
      80 # HTTP
      443 # HTTPS
    ];

    # If you're using Tailscale, you might need to allow UDP port 41641
    allowedUDPPorts = [41641];

    # If you need any specific port ranges, uncomment and adjust these
    # allowedTCPPortRanges = [
    #   { from = 8000; to = 8999; }  # Example range for your services
    # ];

    # Allow incoming connections from your Tailscale network
    trustedInterfaces = ["tailscale0"];

    # If you need to allow incoming connections from specific IP addresses, use this
    # extraCommands = ''
    #   iptables -A INPUT -s your.trusted.ip.address -j ACCEPT
    # '';
  };

  # Enable nftables for newer firewall implementation
  networking.nftables.enable = true;

  # Ensure Tailscale is enabled if you're using it
  services.tailscale.enable = true;

  # You might want to explicitly enable SSH, although it's usually enabled by default
  services.openssh.enable = true;
}
