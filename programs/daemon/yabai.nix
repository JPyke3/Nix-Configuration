{...}: {
  imports = [
    ./skhd.nix
  ];
  services.yabai = {
    enable = true;
    enableScriptingAddition = true;
    config = {
      layout = "bsp";
    };
  };
}
