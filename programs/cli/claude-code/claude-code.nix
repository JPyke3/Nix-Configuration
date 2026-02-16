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
    programs.claude-code = {
      enable = true;
      package = inputs.claude-code.packages.${pkgs.system}.default;
      memory.text = claudeMd;
    };
  };
}
