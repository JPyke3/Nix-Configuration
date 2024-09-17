{
  pkgs,
  inputs,
  ...
}: let
  pkgs_unstable = inputs.unstable.legacyPackages.${pkgs.system};
in {
  imports = [
    ./skhd/skhd.nix
    ./sketchybar/sketchybar.nix
  ];
  services.yabai = {
    enable = false;
    enableScriptingAddition = true;
    package = pkgs_unstable.yabai;
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
