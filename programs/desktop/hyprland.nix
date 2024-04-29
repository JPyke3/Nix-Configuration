{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      general = with config.colorScheme.colors; {
        exec-once = ["waybar" "swww init" "swaync" "[workspace 1 silent] firefox" "[workspace 2 silent] firefox" "[workspace 3 silent] kitty" "[workspace 4 silent] obsidian" "[workspace 5 silent] slack" "[workspace 6 silent] kitty spotify_player" "[workspace 9 silent] steam"];
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
          "workspace 9 silent, class:^(steam)$"
        ];
        exec = "swww img ~/Pictures/Wallpapers/gruvbox-dark-rainbow.png";
        "col.active_border" = "rgba(${base0E}ff) rgba(${base09}ff) 60deg";
        "col.inactive_border" = "rgba(${base00}ff)";
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
