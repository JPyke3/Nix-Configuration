{inputs, ...}: let
in {
  imports = [
    ./skhd/skhd.nix
    ./sketchybar/sketchybar.nix
  ];
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      # General
      layout = "bsp";

      # Focus follows mouse
      focus_follows_mouse = "autoraise";
      mouse_follows_focus = true;

      window_shadow = "float";

      external_bar = "main:20:0";
    };
    extraConfig = ''
      yabai -m rule --add app="^Steam$" title="Steam Helper" space=9
      yabai -m rule --add app="^mpv$" space=10

      yabai -m rule --add app="^System Settings$" manage=off
      yabai -m rule --add app="^Calculator$" manage=off
    '';
  };
}
