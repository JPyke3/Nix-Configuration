{
  pkgs,
  config,
  ...
}: {
  xdg.configFile."nvim/lua/personal_config/theme.lua".text = import ./theme.nix {inherit config;};
}
