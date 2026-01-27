{
  config,
  pkgs,
  lib,
  ...
}: {
  # btop - A modern, colorful system monitor
  # Added by Clawd 🐾
  programs.btop = {
    enable = true;
    
    settings = {
      color_theme = "tokyo-night";
      theme_background = false;  # Transparent background
      vim_keys = true;           # hjkl navigation
      rounded_corners = true;
      update_ms = 1000;          # 1 second refresh
      proc_sorting = "cpu lazy"; # Sort by CPU usage
      proc_tree = true;          # Show process tree
      show_cpu_freq = true;
      show_coretemp = true;
    };
  };
}
