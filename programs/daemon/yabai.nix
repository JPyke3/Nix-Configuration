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

      window_shadow = "float";

      external_bar = "main:20:0";
    };
  };
}
