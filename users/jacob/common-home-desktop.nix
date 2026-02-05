{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  # Desktop/GUI packages
  home.packages = [
    pkgs.spotify-player
    pkgs.zathura
    pkgs.gimp
    pkgs.nomachine-client
  ];

  # Stylix-dependent nvim theme files (requires Stylix module to be loaded)
  xdg.configFile."nvim/lua/personal_config/theme.lua".text = import ../../programs/cli/nvim/theme.nix {inherit config;};
  xdg.configFile."nvim/lua/plugin_config/lualine_config.lua".text = import ../../programs/cli/nvim/lualine_config.nix {inherit config;};
}
