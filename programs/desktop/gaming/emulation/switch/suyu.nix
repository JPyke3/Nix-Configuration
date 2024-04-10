{
  inputs,
  config,
  ...
}: {
  imports = [
    ./secrets/prodkeys.nix
  ];

  home.packages = [
    inputs.jpyke3-suyu.packages.x86_64-linux.suyu-dev
  ];

  home.file."${config.home.homeDirectory}/.local/share/suyu/keys/prod.keys".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/emulation/keys/prod.keys";

  home.file."${config.home.homeDirectory}/.local/share/suyu/nand/user/save".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/data/Games/Saves/Yuzu/save";
}
