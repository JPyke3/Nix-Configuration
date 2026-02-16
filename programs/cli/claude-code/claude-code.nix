# Claude Code configuration module
# Nix manages: package installation, CLAUDE.md
# Everything else is left to Claude Code to manage at runtime
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.jacob.claude-code;
  claudeMd = import ./claude-md.nix {inherit pkgs config lib;};
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
    # LSP server binaries (required for Claude Code's code intelligence plugins)
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

    programs.claude-code = {
      enable = true;
      package = inputs.claude-code.packages.${pkgs.system}.default;
      memory.text = claudeMd;
    };
  };
}
