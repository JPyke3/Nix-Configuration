# Clawdbot Node Host - connects to a remote Clawdbot gateway
# Allows the gateway to run commands on this machine
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.services.clawdbot-node;

  # Get the openclaw package from nix-openclaw flake (formerly clawdbot)
  openclawPkg =
    inputs.nix-openclaw.packages.${
      pkgs.system
    }.openclaw or (
      # Fallback: npx wrapper if flake package not available
      pkgs.writeShellScriptBin "openclaw" ''
        export PATH="${pkgs.nodejs}/bin:$PATH"
        exec ${pkgs.nodejs}/bin/npx -y openclaw "$@"
      ''
    );
in {
  options.services.clawdbot-node = {
    enable = mkEnableOption "Clawdbot node host service";

    package = mkOption {
      type = types.package;
      default = openclawPkg;
      description = "The openclaw package to use";
    };

    gatewayHost = mkOption {
      type = types.str;
      description = "Gateway host address (IP or hostname)";
      example = "192.168.1.100";
    };

    gatewayPort = mkOption {
      type = types.port;
      default = 18789;
      description = "Gateway WebSocket port";
    };

    displayName = mkOption {
      type = types.str;
      default = config.networking.hostName;
      description = "Display name for this node";
    };

    useTls = mkOption {
      type = types.bool;
      default = false;
      description = "Use TLS for gateway connection";
    };

    tlsFingerprint = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Expected TLS fingerprint for gateway (pin to avoid MITM)";
    };

    stateDir = mkOption {
      type = types.str;
      default = "/var/lib/clawdbot-node";
      description = "State directory for node credentials and approvals";
    };

    user = mkOption {
      type = types.str;
      default = "clawdbot";
      description = "User to run the clawdbot node as";
    };

    group = mkOption {
      type = types.str;
      default = "clawdbot";
      description = "Group to run the clawdbot node as";
    };

    extraGroups = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra groups for the clawdbot user (e.g., 'wheel' for sudo access)";
      example = ["wheel" "docker"];
    };
  };

  config = mkIf cfg.enable {
    # Create user and group
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.stateDir;
      createHome = true;
      description = "Clawdbot node service user";
      extraGroups = cfg.extraGroups;
      shell = pkgs.bash;
    };

    users.groups.${cfg.group} = {};

    # Systemd service
    systemd.services.clawdbot-node = {
      description = "Clawdbot Node Host";
      wantedBy = ["multi-user.target"];
      after = ["network-online.target"];
      wants = ["network-online.target"];

      path = with pkgs; [
        nodejs
        git
        coreutils
        bash
        cfg.package
      ];

      environment = {
        HOME = cfg.stateDir;
        CLAWDBOT_STATE_DIR = cfg.stateDir;
        npm_config_cache = "${cfg.stateDir}/.npm";
      };

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;

        ExecStart = let
          tlsArgs = optionalString cfg.useTls " --tls";
          fpArgs = optionalString (cfg.tlsFingerprint != null) " --tls-fingerprint ${cfg.tlsFingerprint}";
        in ''
          ${cfg.package}/bin/openclaw node run \
            --host ${cfg.gatewayHost} \
            --port ${toString cfg.gatewayPort} \
            --display-name ${cfg.displayName}${tlsArgs}${fpArgs}
        '';

        Restart = "always";
        RestartSec = "10s";

        # Hardening (relaxed to allow running user commands)
        NoNewPrivileges = false; # Allow setuid for running commands
        ProtectSystem = "full"; # Allow /etc writes if needed
        ProtectHome = "read-only";
        PrivateTmp = true;
        ReadWritePaths = [cfg.stateDir "/tmp"];
      };
    };

    # Ensure state directory exists with correct permissions
    systemd.tmpfiles.rules = [
      "d ${cfg.stateDir} 0750 ${cfg.user} ${cfg.group} -"
      "d ${cfg.stateDir}/.npm 0750 ${cfg.user} ${cfg.group} -"
    ];
  };
}
