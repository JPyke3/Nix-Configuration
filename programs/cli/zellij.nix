{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.zellij = {
    enable = true;
    enableZshIntegration = false; # Don't auto-start zellij, just add to PATH

    settings = {
      # Simplified UI - good for mobile and clean look
      pane_frames = false;
      simplified_ui = true;

      # Default layout
      default_layout = "compact";

      # Theme will be handled by Stylix automatically
      # Stylix applies base16 colors to zellij when enabled
    };
  };
}
