# Attic - Self-hosted Nix Binary Cache Server
# Runs on china, stores data on Synology NAS via NFS mount
{
  config,
  pkgs,
  inputs,
  ...
}: let
  # Attic server configuration
  atticConfig = {
    listen = "[::]:5000";

    # Use filesystem storage on NFS-mounted Synology
    storage = {
      type = "local";
      path = "/nix-cache/storage";
    };

    # SQLite database for metadata (stored locally on china for performance)
    database = {
      url = "sqlite:///var/lib/atticd/server.db?mode=rwc";
    };

    # Chunking settings for deduplication
    chunking = {
      nar-size-threshold = 65536; # 64 KiB - chunk NARs larger than this
      min-size = 16384; # 16 KiB minimum chunk size
      avg-size = 65536; # 64 KiB average chunk size
      max-size = 262144; # 256 KiB maximum chunk size
    };

    # Garbage collection settings
    garbage-collection = {
      # Keep derivations for 30 days after last access
      default-retention-period = "30 days";
      interval = "24 hours";
    };

    # Compression
    compression = {
      type = "zstd";
      level = 8;
    };
  };

  # Generate TOML configuration file
  atticConfigFile = (pkgs.formats.toml {}).generate "atticd.toml" atticConfig;
in {
  # Import attic from flake input
  imports = [];

  # Create atticd user and group
  users.users.atticd = {
    isSystemUser = true;
    group = "atticd";
    home = "/var/lib/atticd";
    createHome = true;
  };
  users.groups.atticd = {};

  # Ensure storage directories exist with correct permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/atticd 0750 atticd atticd -"
    "d /nix-cache/storage 0750 atticd atticd -"
  ];

  # SOPS secret for Attic server credentials
  sops.secrets."attic/server-token" = {
    owner = "atticd";
    group = "atticd";
    mode = "0400";
  };

  # Attic daemon service
  systemd.services.atticd = {
    description = "Attic Binary Cache Server";
    wantedBy = ["multi-user.target"];
    # Note: systemd escapes hyphens in mount paths as \x2d
    after = ["network-online.target" "nix\\x2dcache.mount"];
    wants = ["network-online.target"];
    requires = ["nix\\x2dcache.mount"];

    serviceConfig = {
      ExecStart = "${pkgs.attic-server}/bin/atticd --config ${atticConfigFile}";
      # Load the secret from file into environment variable
      EnvironmentFile = config.sops.secrets."attic/server-token".path;
      User = "atticd";
      Group = "atticd";
      StateDirectory = "atticd";
      Restart = "on-failure";
      RestartSec = "5s";

      # Hardening
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      PrivateTmp = true;
      ReadWritePaths = ["/var/lib/atticd" "/nix-cache"];
    };
  };

  # Open firewall for Tailscale access only
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [5000];

  # Install attic-client for local management
  environment.systemPackages = [pkgs.attic-client];
}
