{
  pkgs,
  config,
  ...
}: {
  xdg.configFile."nvim/lua/personal_config/theme.lua".text = import ./theme.nix {inherit config;};
  xdg.configFile."nvim/lua/plugin_config/lualine_config.lua".text = import ./lualine_config.nix {inherit pkgs;};
}
