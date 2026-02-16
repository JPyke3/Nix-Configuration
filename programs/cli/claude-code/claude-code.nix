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

  # LSP configuration with full Nix store paths (bypasses FHS discovery bug on NixOS)
  lspConfig = {
    nix = {
      command = "${pkgs.nixd}/bin/nixd";
      args = [];
      extensionToLanguage = {".nix" = "nix";};
    };
    clangd = {
      command = "${pkgs.clang-tools}/bin/clangd";
      args = [];
      extensionToLanguage = {
        ".c" = "c";
        ".h" = "c";
        ".cpp" = "cpp";
        ".hpp" = "cpp";
        ".cc" = "cpp";
        ".cxx" = "cpp";
      };
    };
    csharp = {
      command = "${pkgs.csharp-ls}/bin/csharp-ls";
      args = [];
      extensionToLanguage = {".cs" = "csharp";};
    };
    go = {
      command = "${pkgs.gopls}/bin/gopls";
      args = [];
      extensionToLanguage = {".go" = "go";};
    };
    java = {
      command = "${pkgs.jdt-language-server}/bin/jdtls";
      args = [];
      extensionToLanguage = {".java" = "java";};
    };
    kotlin = {
      command = "${pkgs.kotlin-language-server}/bin/kotlin-language-server";
      args = [];
      extensionToLanguage = {
        ".kt" = "kotlin";
        ".kts" = "kotlin";
      };
    };
    lua = {
      command = "${pkgs.lua-language-server}/bin/lua-language-server";
      args = [];
      extensionToLanguage = {".lua" = "lua";};
    };
    php = {
      command = "${pkgs.nodePackages.intelephense}/bin/intelephense";
      args = ["--stdio"];
      extensionToLanguage = {".php" = "php";};
    };
    python = {
      command = "${pkgs.pyright}/bin/pyright-langserver";
      args = ["--stdio"];
      extensionToLanguage = {".py" = "python";};
    };
    rust = {
      command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
      args = [];
      extensionToLanguage = {".rs" = "rust";};
    };
    swift = {
      command = "${pkgs.sourcekit-lsp}/bin/sourcekit-lsp";
      args = [];
      extensionToLanguage = {".swift" = "swift";};
    };
    typescript = {
      command = "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server";
      args = ["--stdio"];
      extensionToLanguage = {
        ".ts" = "typescript";
        ".tsx" = "typescriptreact";
        ".js" = "javascript";
        ".jsx" = "javascriptreact";
      };
    };
  };

  # Session context script (runs at session start to provide context to Claude)
  # Pass platform flags to conditionally include relevant sections
  sessionContextScript = import ./session-context.nix {
    inherit pkgs lib;
    inherit isLinux isDarwin isDesktop;
    isHeadless = cfg.headless;
    isMobile = cfg.mobile;
  };

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
    # Language server binaries for Claude Code's code intelligence plugins
    home.packages = [
      pkgs.clang-tools # clangd (C/C++)
      pkgs.csharp-ls # csharp-ls (C#)
      pkgs.gopls # gopls (Go)
      pkgs.jdt-language-server # jdtls (Java)
      pkgs.kotlin-language-server # kotlin-language-server (Kotlin)
      pkgs.lua-language-server # lua-language-server (Lua)
      pkgs.nodePackages.intelephense # intelephense (PHP)
      pkgs.pyright # pyright-langserver (Python)
      pkgs.rust-analyzer # rust-analyzer (Rust)
      pkgs.sourcekit-lsp # sourcekit-lsp (Swift)
      pkgs.nodePackages.typescript-language-server # typescript-language-server (TypeScript)
      pkgs.nixd # nixd (Nix)
    ];

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
            # Code intelligence LSP plugins
            "clangd-lsp" = true;
            "csharp-lsp" = true;
            "gopls-lsp" = true;
            "jdtls-lsp" = true;
            "kotlin-lsp" = true;
            "lua-lsp" = true;
            "php-lsp" = true;
            "pyright-lsp" = true;
            "rust-analyzer-lsp" = true;
            "swift-lsp" = true;
            "typescript-lsp" = true;
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

        # LSP config with full Nix store paths (workaround for NixOS FHS discovery bug)
        ".claude/.lsp.json".text = builtins.toJSON lspConfig;
      }
      // lib.optionalAttrs isLinuxDesktop {
        # Icon only needed on Linux (macOS uses system notifications)
        ".claude/icons/claude.png".source = claudeIcon;
      };

    # Seed config files ONLY if they don't exist (preserves runtime modifications)
    home.activation.seedClaudeConfigs = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${pkgs.coreutils}/bin/mkdir -p "$HOME/.claude/plugins"

      CONFIG_FILE="$HOME/.claude/settings.local.json"
      if [ ! -f "$CONFIG_FILE" ]; then
        ${pkgs.coreutils}/bin/cat > "$CONFIG_FILE" << 'EOF'
      ${builtins.toJSON permissionRules}
      EOF
        echo "Seeded Claude Code permissions"
      fi

      MARKETPLACES_FILE="$HOME/.claude/plugins/known_marketplaces.json"
      if [ ! -f "$MARKETPLACES_FILE" ]; then
        ${pkgs.coreutils}/bin/cat > "$MARKETPLACES_FILE" << 'EOF'
      ${builtins.toJSON knownMarketplaces}
      EOF
        echo "Seeded Claude Code marketplaces"
      fi

      PLUGINS_FILE="$HOME/.claude/plugins/installed_plugins.json"
      if [ ! -f "$PLUGINS_FILE" ]; then
        ${pkgs.coreutils}/bin/cat > "$PLUGINS_FILE" << 'EOF'
      ${builtins.toJSON installedPlugins}
      EOF
        echo "Seeded Claude Code plugins"
      fi
    '';
  };
}
