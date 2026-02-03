# Clawdbot Node Host - Home Manager module
# Runs as user service, connects to a remote Clawdbot gateway
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
  openclawPkg = inputs.nix-openclaw.packages.${pkgs.system}.openclaw;
in {
  options.services.clawdbot-node = {
    enable = mkEnableOption "Clawdbot node host service (user)";

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
      default = config.home.username;
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
  };

  config = mkIf cfg.enable {
    # Create a wrapper script for just the openclaw binary (avoids git conflicts)
    home.packages = [
      (pkgs.writeShellScriptBin "openclaw" ''
        exec ${cfg.package}/bin/openclaw "$@"
      '')
    ];

    # Systemd user service
    systemd.user.services.clawdbot-node = {
      Unit = {
        Description = "Clawdbot Node Host";
        After = ["network-online.target" "graphical-session.target"];
        Wants = ["network-online.target"];
        PartOf = ["graphical-session.target"];
      };

      Service = {
        Type = "simple";
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

        # Inherit user environment for display access
        Environment = [
          "PATH=${cfg.package}/bin:/run/current-system/sw/bin"
        ];
      };

      Install = {
        WantedBy = ["graphical-session.target"];
      };
    };
  };
}
