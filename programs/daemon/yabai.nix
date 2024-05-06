{
  inputs,
  pkgs,
  ...
}: let
  pkgs_unstable = import inputs.unstable.legacyPackages.${pkgs.system};
in {
  imports = [
    ./skhd/skhd.nix
    ./sketchybar/sketchybar.nix
  ];
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      layout = "bsp";
    };
  };
}
