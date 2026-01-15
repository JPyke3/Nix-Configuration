# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.vpnconfinement.nixosModules.default
    ./hardware-configuration.nix
    ../../../programs/daemon/arr.nix # Media Server Stack
    ../../../programs/daemon/vaultwarden.nix
    ../../../programs/daemon/acme.nix
    ../../../programs/daemon/nginx.nix
    ../../../programs/daemon/matter.nix
    # ../../../programs/daemon/stash.nix  # Disabled - /adult volume removed from NAS
    ../../../programs/daemon/mylar.nix
    ../../../programs/daemon/komga.nix
    ../../../programs/daemon/attic.nix # Self-hosted Nix binary cache
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
      "komga"
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

  # Attic database backup to NAS
  systemd.services.attic-backup = {
    description = "Backup Attic database to NAS";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "attic-backup" ''
        set -euo pipefail

        DB_PATH="/var/lib/atticd/server.db"
        BACKUP_DIR="/nix-cache/backups"
        BACKUP_PATH="$BACKUP_DIR/server-$(date +%Y%m%d).db"

        # Ensure database exists
        if [ ! -f "$DB_PATH" ]; then
          echo "Database not found: $DB_PATH"
          exit 1
        fi

        # Perform backup
        ${pkgs.sqlite}/bin/sqlite3 "$DB_PATH" ".backup '$BACKUP_PATH'"

        # Verify backup succeeded
        if [ ! -s "$BACKUP_PATH" ]; then
          echo "Backup failed: $BACKUP_PATH is empty"
          exit 1
        fi

        # Cleanup old backups (only if backups exist)
        if compgen -G "$BACKUP_DIR/server-*.db" > /dev/null; then
          ls -t "$BACKUP_DIR"/server-*.db | tail -n +8 | xargs -r rm
        fi

        echo "Backup successful: $BACKUP_PATH"
      '';
      User = "atticd";
    };
  };

  systemd.timers.attic-backup = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };

  # Ensure backup directory exists
  systemd.tmpfiles.rules = [
    "d /nix-cache/backups 0750 atticd atticd -"
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

  # Disable USB gadget bridge - not needed on server and incompatible with nftables
  jpyke3.usbGadgetBridge.enable = lib.mkForce false;

  # Ensure Tailscale is enabled if you're using it
  services.tailscale.enable = true;

  # You might want to explicitly enable SSH, although it's usually enabled by default
  services.openssh.enable = true;
}
