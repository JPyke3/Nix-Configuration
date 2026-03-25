{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  noctalia = inputs.noctalia-shell.packages.${pkgs.system}.default;
in {
  imports = [
    inputs.niri.homeModules.niri
    inputs.niri.homeModules.stylix
  ];

  programs.niri.settings = {
    # =========================================================================
    # Environment
    # =========================================================================
    environment = {
      "NIXOS_OZONE_WL" = "1";
      "DISPLAY" = ":0";
    };

    # =========================================================================
    # Input
    # =========================================================================
    input = {
      touchpad = {
        tap = true;
        natural-scroll = true;
      };
    };

    # =========================================================================
    # Layout
    # =========================================================================
    layout = {
      gaps = 0;
      border = {
        enable = true;
        width = 2;
        active.gradient = {
          from = "#${config.lib.stylix.colors.base0E}";
          to = "#${config.lib.stylix.colors.base09}";
          angle = 60;
        };
        inactive.color = "#${config.lib.stylix.colors.base00}";
      };
      focus-ring.enable = false;
      shadow.enable = false;
      preset-column-widths = [
        {proportion = 1.0 / 3.0;}
        {proportion = 1.0 / 2.0;}
        {proportion = 2.0 / 3.0;}
        {proportion = 1.0;}
      ];
    };

    # =========================================================================
    # Startup applications
    # =========================================================================
    spawn-at-startup = [
      {command = ["${pkgs.xwayland-satellite}/bin/xwayland-satellite"];}
      {command = ["fcitx5" "-d"];}
      {command = ["${noctalia}/bin/noctalia-shell"];}
    ];

    # =========================================================================
    # Window rules
    # =========================================================================
    window-rules = [
      # Firefox Picture-in-Picture → floating
      {
        matches = [
          {
            app-id = "^firefox$";
            title = "^Picture-in-Picture$";
          }
        ];
        open-floating = true;
        default-column-width = {fixed = 800;};
        default-window-height = {fixed = 450;};
      }
      # xwaylandvideobridge → hidden
      {
        matches = [{app-id = "^xwaylandvideobridge$";}];
        opacity = 0.0;
        open-floating = true;
      }
    ];

    # =========================================================================
    # Layer rules (Noctalia wallpaper integration)
    # =========================================================================
    layer-rules = [
      {
        matches = [{namespace = "^noctalia-wallpaper.*";}];
        place-within-backdrop = true;
      }
    ];

    # =========================================================================
    # Keybindings
    # =========================================================================
    binds = {
      # --- Applications ---
      "Mod+Return".action.spawn = "kitty";
      "Mod+D".action.spawn = ["${noctalia}/bin/noctalia-shell" "ipc" "call" "launcher" "toggle"];
      "Mod+Shift+Q".action.close-window = [];
      "Mod+Shift+N".action.spawn = ["${noctalia}/bin/noctalia-shell" "ipc" "call" "notifications" "toggleHistory"];
      "Mod+Shift+E".action.quit = {};

      # --- Focus (vim-style) ---
      "Mod+H".action.focus-column-left = [];
      "Mod+J".action.focus-window-down = [];
      "Mod+K".action.focus-window-up = [];
      "Mod+L".action.focus-column-right = [];
      "Mod+Left".action.focus-column-left = [];
      "Mod+Down".action.focus-window-down = [];
      "Mod+Up".action.focus-window-up = [];
      "Mod+Right".action.focus-column-right = [];

      # --- Move windows ---
      "Mod+Ctrl+H".action.move-column-left = [];
      "Mod+Ctrl+J".action.move-window-down = [];
      "Mod+Ctrl+K".action.move-window-up = [];
      "Mod+Ctrl+L".action.move-column-right = [];

      # --- Resize ---
      "Mod+Alt+H".action.set-column-width = "-10%";
      "Mod+Alt+L".action.set-column-width = "+10%";
      "Mod+Alt+K".action.set-window-height = "-10%";
      "Mod+Alt+J".action.set-window-height = "+10%";

      # --- Column management ---
      "Mod+F".action.maximize-column = [];
      "Mod+Shift+F".action.fullscreen-window = [];
      "Mod+C".action.center-column = [];
      "Mod+V".action.toggle-window-floating = [];
      "Mod+R".action.switch-preset-column-width = [];
      "Mod+Comma".action.consume-window-into-column = [];
      "Mod+Period".action.expel-window-from-column = [];

      # --- Workspaces ---
      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;
      "Mod+0".action.focus-workspace = 10;

      "Mod+Shift+1".action.move-column-to-workspace = 1;
      "Mod+Shift+2".action.move-column-to-workspace = 2;
      "Mod+Shift+3".action.move-column-to-workspace = 3;
      "Mod+Shift+4".action.move-column-to-workspace = 4;
      "Mod+Shift+5".action.move-column-to-workspace = 5;
      "Mod+Shift+6".action.move-column-to-workspace = 6;
      "Mod+Shift+7".action.move-column-to-workspace = 7;
      "Mod+Shift+8".action.move-column-to-workspace = 8;
      "Mod+Shift+9".action.move-column-to-workspace = 9;
      "Mod+Shift+0".action.move-column-to-workspace = 10;

      "Mod+Page_Up".action.focus-workspace-up = [];
      "Mod+Page_Down".action.focus-workspace-down = [];
      "Mod+Ctrl+Page_Up".action.move-column-to-workspace-up = [];
      "Mod+Ctrl+Page_Down".action.move-column-to-workspace-down = [];

      # --- Overview ---
      "Mod+O".action.toggle-overview = [];

      # --- Screenshots ---
      "Print".action.screenshot = [];
      "Ctrl+Print".action.screenshot-screen = [];
      "Alt+Print".action.screenshot-window = [];

      # --- Monitor power ---
      "Mod+Shift+P".action.power-off-monitors = [];

      # --- Media keys ---
      "XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05+"];
      };
      "XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.05-"];
      };
      "XF86AudioMute" = {
        allow-when-locked = true;
        action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
      };
      "XF86AudioMicMute" = {
        allow-when-locked = true;
        action.spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
      };
      "XF86MonBrightnessUp".action.spawn = ["brightnessctl" "set" "+5%"];
      "XF86MonBrightnessDown".action.spawn = ["brightnessctl" "set" "5%-"];

      # --- Mouse ---
      "Mod+WheelScrollDown".action.focus-workspace-down = [];
      "Mod+WheelScrollUp".action.focus-workspace-up = [];
    };
  };
}
