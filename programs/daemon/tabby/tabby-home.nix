{config, ...}: {
  home.file."${config.home.homeDirectory}/.tabby/config.toml".source = ./config.toml;
}
