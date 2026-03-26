{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inir = inputs.inir.packages.${pkgs.system}.default;
  qs = "${inir}/bin/inir-shell";
  # IPC helper — ensures QS_CONFIG_PATH matches the running instance
  ipc = pkgs.writeShellScript "inir-ipc" ''
    export QS_CONFIG_PATH="${inir}/share/inir"
    exec ${qs} "$@"
  '';
in {
  imports = [
    inputs.niri.homeModules.niri
    inputs.niri.homeModules.stylix
  ];

  programs.niri.settings = {
    # =========================================================================
    # Top-level settings (from iNiR defaults)
    # =========================================================================
    prefer-no-csd = true;
    hotkey-overlay.skip-at-startup = true;

    # =========================================================================
    # Environment (aligned with iNiR defaults/niri/config.kdl)
    # =========================================================================
    environment = {
      "NIXOS_OZONE_WL" = "1";
      "DISPLAY" = ":0";
      "XDG_CURRENT_DESKTOP" = "niri";
      "QT_QPA_PLATFORM" = "wayland";
      "QT_QPA_PLATFORMTHEME" = "kde";
      "QT_STYLE_OVERRIDE" = "Darkly";
      "QT_LOGGING_RULES" = "quickshell.dbus.properties=false";
      "ELECTRON_OZONE_PLATFORM_HINT" = "auto";
      "MALLOC_ARENA_MAX" = "2";
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
    # Cursor
    # =========================================================================
    cursor = {
      hide-when-typing = true;
    };

    # =========================================================================
    # Overview
    # =========================================================================
    overview.zoom = 0.75;

    # =========================================================================
    # Layout (background-color transparent is CRITICAL for iNiR transparency)
    # =========================================================================
    layout = {
      gaps = 16;
      background-color = "transparent";
      border = {
        enable = false;
      };
      focus-ring.enable = false;
      shadow = {
        enable = true;
        softness = 30;
        spread = 5;
        offset = {
          x = 0;
          y = 5;
        };
        color = "#0007";
      };
      preset-column-widths = [
        {proportion = 1.0 / 3.0;}
        {proportion = 1.0 / 2.0;}
        {proportion = 2.0 / 3.0;}
        {proportion = 1.0;}
      ];
      default-column-width = {proportion = 0.5;};
    };

    # =========================================================================
    # Animations (tuned for iNiR's Material motion curves)
    # =========================================================================
    animations = {
      workspace-switch.spring = {
        damping-ratio = 0.78;
        stiffness = 600;
        epsilon = 0.0001;
      };
      window-open.spring = {
        damping-ratio = 0.82;
        stiffness = 500;
        epsilon = 0.0001;
      };
      window-close.spring = {
        damping-ratio = 0.88;
        stiffness = 900;
        epsilon = 0.0001;
      };
      horizontal-view-movement.spring = {
        damping-ratio = 0.80;
        stiffness = 550;
        epsilon = 0.0001;
      };
      window-movement.spring = {
        damping-ratio = 0.85;
        stiffness = 650;
        epsilon = 0.0001;
      };
      window-resize.spring = {
        damping-ratio = 0.88;
        stiffness = 700;
        epsilon = 0.0001;
      };
      config-notification-open-close.spring = {
        damping-ratio = 0.90;
        stiffness = 800;
        epsilon = 0.0001;
      };
    };

    # =========================================================================
    # Startup applications
    # =========================================================================
    spawn-at-startup = [
      {command = ["${pkgs.xwayland-satellite}/bin/xwayland-satellite"];}
      {command = ["fcitx5" "-d"];}
      {command = ["bash" "-c" "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store &"];}
      {command = [qs];}
    ];

    # =========================================================================
    # Window rules
    # =========================================================================
    window-rules = [
      # Global: rounded corners + clip
      {
        geometry-corner-radius = let
          r = 16.0;
        in {
          top-left = r;
          top-right = r;
          bottom-left = r;
          bottom-right = r;
        };
        clip-to-geometry = true;
      }
      # Inactive windows slightly transparent
      {
        matches = [{is-active = false;}];
        opacity = 0.9;
      }
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
      # Quickshell windows (iNiR settings, etc.) → no decorations, floating
      {
        matches = [{app-id = "^org\\.quickshell$";}];
        open-floating = true;
        draw-border-with-background = false;
      }
      # xwaylandvideobridge → hidden
      {
        matches = [{app-id = "^xwaylandvideobridge$";}];
        opacity = 0.0;
        open-floating = true;
      }
    ];

    # =========================================================================
    # Layer rules (iNiR backdrop visibility during overview)
    # =========================================================================
    layer-rules = [
      {
        matches = [{namespace = "^quickshell:iiBackdrop$";}];
        place-within-backdrop = true;
        opacity = 1.0;
      }
      {
        matches = [{namespace = "^quickshell:wBackdrop$";}];
        place-within-backdrop = true;
        opacity = 1.0;
      }
    ];

    # =========================================================================
    # Keybindings
    # =========================================================================
    binds = {
      # --- Applications ---
      "Mod+Return".action.spawn = "kitty";
      "Mod+Shift+Q".action.close-window = [];
      "Mod+Shift+E".action.quit = {};

      # --- iNiR Shell IPC ---
      "Mod+G".action.spawn = ["${ipc}" "ipc" "call" "overlay" "toggle"];
      "Mod+Space".action.spawn = ["${ipc}" "ipc" "call" "overview" "toggle"];
      "Mod+D".action.spawn = ["${ipc}" "ipc" "call" "overlay" "toggle"];
      "Mod+Shift+N".action.spawn = ["${ipc}" "ipc" "call" "notifications" "clearAll"];
      "Mod+Shift+S".action.spawn = ["${ipc}" "ipc" "call" "region" "screenshot"];
      "Mod+Shift+X".action.spawn = ["${ipc}" "ipc" "call" "region" "ocr"];
      "Mod+Slash".action.spawn = ["${ipc}" "ipc" "call" "cheatsheet" "toggle"];
      "Mod+Shift+W".action.spawn = ["${ipc}" "ipc" "call" "panelFamily" "cycle"];
      "Mod+Semicolon".action.spawn = ["${ipc}" "ipc" "call" "settings" "open"];
      "Ctrl+Alt+T".action.spawn = ["${ipc}" "ipc" "call" "wallpaperSelector" "toggle"];
      "Alt+Tab".action.spawn = ["${ipc}" "ipc" "call" "altSwitcher" "next"];
      "Alt+Shift+Tab".action.spawn = ["${ipc}" "ipc" "call" "altSwitcher" "previous"];
      "Ctrl+Alt+L" = {
        allow-when-locked = true;
        action.spawn = ["${ipc}" "ipc" "call" "lock" "activate"];
      };

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

      # --- Media keys (via iNiR IPC for OSD) ---
      "XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action.spawn = ["${ipc}" "ipc" "call" "audio" "volumeUp"];
      };
      "XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action.spawn = ["${ipc}" "ipc" "call" "audio" "volumeDown"];
      };
      "XF86AudioMute" = {
        allow-when-locked = true;
        action.spawn = ["${ipc}" "ipc" "call" "audio" "mute"];
      };
      "XF86AudioMicMute" = {
        allow-when-locked = true;
        action.spawn = ["${ipc}" "ipc" "call" "audio" "micMute"];
      };
      "XF86MonBrightnessUp" = {
        allow-when-locked = true;
        action.spawn = ["${ipc}" "ipc" "call" "brightness" "increment"];
      };
      "XF86MonBrightnessDown" = {
        allow-when-locked = true;
        action.spawn = ["${ipc}" "ipc" "call" "brightness" "decrement"];
      };
      "XF86AudioPlay".action.spawn = ["${ipc}" "ipc" "call" "mpris" "playPause"];
      "XF86AudioNext".action.spawn = ["${ipc}" "ipc" "call" "mpris" "next"];
      "XF86AudioPrev".action.spawn = ["${ipc}" "ipc" "call" "mpris" "previous"];

      # --- Mouse ---
      "Mod+WheelScrollDown".action.focus-workspace-down = [];
      "Mod+WheelScrollUp".action.focus-workspace-up = [];
    };
  };
}
