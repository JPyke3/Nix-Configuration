{
  pkgs,
  config,
  ...
}: {
  xdg.configFile."nvim/lua/personal_config/theme.lua" = import ./theme.nix {inherit config;};
}
