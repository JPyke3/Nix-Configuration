{...}: {
  imports = [
    ./skhd.nix
    ./sketchybar.nix
  ];
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      layout = "bsp";
    };
  };
}
