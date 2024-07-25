{config, ...}: {
  home.file."${config.home.homeDirectory}/.config/tabby/config.toml".source = ./config.toml;
}
