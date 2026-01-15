# Claude Code configuration module
# Provides declarative management of Claude Code settings, hooks, and plugins
# with platform-aware notifications and Nix store path resolution
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.jacob.claude-code;

  # Platform detection
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  isDesktop = !cfg.headless && !cfg.mobile;
  isLinuxDesktop = isLinux && isDesktop;
  isDarwinDesktop = isDarwin && isDesktop;

  # Icon path in Nix store
  claudeIcon = ./icons/claude.png;

  # Platform-specific notification commands with FULL NIX PATHS
  notifyCommand =
    if isLinuxDesktop
    then "${pkgs.coreutils}/bin/cat > /dev/null; ${pkgs.libnotify}/bin/notify-send --app-name='Claude Code' --urgency=critical --icon=${claudeIcon}"
    else if isDarwinDesktop
    then ''${pkgs.coreutils}/bin/cat > /dev/null; /usr/bin/osascript -e 'display notification "$2" with title "$1" sound name "Glass"' --''
    else null;

  # Generate statusline script with Nix package paths
  statuslineScript = import ./statusline.nix {inherit pkgs;};

  # Generate CLAUDE.md with package path interpolation
  claudeMd = import ./claude-md.nix {inherit pkgs config lib;};

  # Permission rules as Nix attrset
  permissionRules = import ./settings-local.nix {inherit pkgs;};

  # Marketplace definitions
  knownMarketplaces = import ./marketplaces.nix {inherit config;};

  # Installed plugins
  installedPlugins = import ./plugins.nix {inherit config;};

  # Session context script (runs at session start to provide context to Claude)
  sessionContextScript = import ./session-context.nix {inherit pkgs;};

  # SessionStart hooks - always enabled to provide context
  contextHooks = {
    SessionStart = [
      {
        matcher = "startup";
        hooks = [
          {
            type = "command";
            command = "${sessionContextScript}";
          }
        ];
      }
      {
        matcher = "compact";
        hooks = [
          {
            type = "command";
            command = "${sessionContextScript}";
          }
        ];
      }
    ];
  };

  # Build hooks only when notifications enabled
  notificationHooks = lib.optionalAttrs (notifyCommand != null) {
    Notification = [
      {
        matcher = "*";
        hooks = [
          {
            type = "command";
            command = "${notifyCommand} 'Claude Code - Input Needed' 'Claude is waiting for your response'";
          }
        ];
      }
    ];
    Stop = [
      {
        hooks = [
          {
            type = "command";
            command = "${notifyCommand} 'Claude Code - Task Complete' 'Claude has finished responding'";
          }
        ];
      }
    ];
    PermissionRequest = [
      {
        matcher = "*";
        hooks = [
          {
            type = "command";
            command = "${notifyCommand} 'Claude Code - Permission Needed' 'Claude needs your approval to proceed'";
          }
        ];
      }
    ];
  };
in {
  options.jacob.claude-code = {
    enable = lib.mkEnableOption "Jacob's Claude Code configuration";

    headless = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether this is a headless server (disables notification hooks)";
    };

    mobile = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether this is a mobile device (disables notification hooks)";
    };
  };

  config = lib.mkIf cfg.enable {
    # Official home-manager module for Claude Code
    programs.claude-code = {
      enable = true;
      package = inputs.claude-code.packages.${pkgs.system}.default;

      # CLAUDE.md generated from Nix (simplified - core identity only)
      memory.text = claudeMd;

      # Settings with platform-aware hooks
      settings =
        {
          model = "opus";
          alwaysThinkingEnabled = true;
          statusLine = {
            type = "command";
            command = "${pkgs.bash}/bin/bash $HOME/.claude/statusline.sh";
          };
          enabledPlugins = {
            "frontend-design@claude-code-plugins" = true;
            "security-guidance@claude-code-plugins" = true;
            "payload@payload-marketplace" = true;
            "frontend-mobile-development@claude-code-workflows" = true;
          };
        }
        // {
          # Always include context hooks, optionally merge notification hooks
          hooks = contextHooks // lib.optionalAttrs (notifyCommand != null) notificationHooks;
        };
    };

    # Supplementary files via home.file (immutable configs only)
    home.file =
      {
        # Statusline script (generated with Nix paths)
        ".claude/statusline.sh" = {
          text = statuslineScript;
          executable = true;
        };

        # Plugin config (Claude Code manages plugin cache, we just seed the registry)
        ".claude/plugins/known_marketplaces.json".text = builtins.toJSON knownMarketplaces;
        ".claude/plugins/installed_plugins.json".text = builtins.toJSON installedPlugins;
      }
      // lib.optionalAttrs isLinuxDesktop {
        # Icon only needed on Linux (macOS uses system notifications)
        ".claude/icons/claude.png".source = claudeIcon;
      };

    # Seed permissions file ONLY if it doesn't exist (preserves runtime modifications)
    home.activation.seedClaudePermissions = lib.hm.dag.entryAfter ["writeBoundary"] ''
            CONFIG_FILE="$HOME/.claude/settings.local.json"
            if [ ! -f "$CONFIG_FILE" ]; then
              ${pkgs.coreutils}/bin/mkdir -p "$HOME/.claude"
              ${pkgs.coreutils}/bin/cat > "$CONFIG_FILE" << 'EOF'
      ${builtins.toJSON permissionRules}
      EOF
              echo "Seeded Claude Code permissions"
            fi
    '';
  };
}
