{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hyprlock.nix
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      general = with config.colorScheme.palette; {
        monitor = "eDP-1, 3024x1890@60, 0x0, 2";
        exec-once = ["waybar" "swww init" "swaync" "jellyfin-mpv-shim" "[workspace 1 silent] firefox" "[workspace 2 silent] firefox" "[workspace 3 silent] kitty tmux" "[workspace 4 silent] obsidian" "[workspace 5 silent] slack" "[workspace 6 silent] kitty spotify_player" "[workspace 7 silent] armcord" "[workspace 9 silent] steam" "/usr/lib/polkit-kde-authentication-agent-1"];
        windowrulev2 = [
          "float, title:^(Picture-in-Picture|Firefox)$"
          "size 800 450, title:^(Picture-in-Picture|Firefox)$"
          "pin, title:^(Picture-in-Picture|Firefox)$"
          "stayfocused, title:^()$,class:^(steam)$"
          "opacity 0.0 override,class:^(xwaylandvideobridge)$"
          "noanim,class:^(xwaylandvideobridge)$"
          "noinitialfocus,class:^(xwaylandvideobridge)$"
          "maxsize 1 1,class:^(xwaylandvideobridge)$"
          "noblur,class:^(xwaylandvideobridge)$"
          "workspace 7 silent, class:^([Aa]rm[Cc]ord)$"
          "workspace 9 silent, class:^([Ss]team)$"
          "workspace 10, class:^(mpv)$"
        ];
        exec = "swww img ~/Pictures/Wallpapers/catppuccin-japan.png";
        "col.active_border" = lib.mkForce "rgba(${base0E}ff) rgba(${base09}ff) 60deg";
        "col.inactive_border" = lib.mkForce "rgba(${base00}ff)";
        gaps_in = 0;
        gaps_out = 0;
      };
      "$mod" = "SUPER";
      "$left" = "H";
      "$down" = "J";
      "$up" = "K";
      "$right" = "L";
      bindm = [
        "ALT,mouse:272,movewindow"
        "$mod ALT,mouse:272,resizewindow"
      ];
      bind =
        [
          "$mod, D, exec, wofi --show=run"
          "$mod, F, fullscreen"
          "$mod, RETURN, exec, kitty"
          "$mod SHIFT, Q, killactive"
          "$mod SHIFT, N, exec, swaync-client -t -sw"
          "$mod, $left, movefocus, l"
          "$mod, $down, movefocus, d"
          "$mod, $up, movefocus, u"
          "$mod, $right, movefocus, r"
          "$mod ALT, $left, resizeactive, -160, 0"
          "$mod ALT, $down, resizeactive, 0, 160"
          "$mod ALT, $up, resizeactive, 0, -160"
          "$mod ALT, $right, resizeactive, 160, 0"
          "$mod, C, togglespecialworkspace"
          "$mod SHIFT, C, movetoworkspace, special"
          "$mod SHIFT, E, exec, ${pkgs.wlogout}/bin/wlogout"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
            10)
        );
    };
  };
}
