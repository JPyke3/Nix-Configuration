{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      general = with config.colorScheme.colors; {
        exec-once = ["waybar" "swww init" "swaync"];
        follow_mouse = 1;
        mouse_refocus = false;
        windowrulev2 = [
          "float, title:^(Picture-in-Picture|Firefox)$"
          "size 800 450, title:^(Picture-in-Picture|Firefox)$"
          "pin, title:^(Picture-in-Picture|Firefox)$"
        ];
        exec = "swww img ~/Pictures/Wallpapers/gruvbox-dark-rainbow.png";
        "col.active_border" = "rgba(${base0E}ff) rgba(${base09}ff) 60deg";
        "col.inactive_border" = "rgba(${base00}ff)";
      };
      "$mod" = "SUPER";
      bindm = [
        "ALT,mouse:272,movewindow"
        "$mod ALT,mouse:272,resizewindow"
      ];
      bind =
        [
          "$mod, D, exec, wofi --show=run"
          "$mod, F, fullscreen"
          "$mod, RETURN, exec, alacritty"
          "$mod SHIFT, Q, killactive"
          "$mod SHIFT, N, exec, swaync-client -t -sw"
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
