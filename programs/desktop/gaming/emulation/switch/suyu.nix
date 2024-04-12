{
  pkgs,
  inputs,
  config,
  system,
  ...
}: let
  nur-no-pkgs = import inputs.nur {
    nurpkgs = import inputs.nixpkgs {system = "x86_64-linux";};
  };
in {
  imports = [
    ./secrets/prodkeys.nix
  ];

  home.packages = [
    inputs.nur.repos.jpyke3.suyu-dev
  ];

  home.file."${config.home.homeDirectory}/.local/share/suyu/keys/prod.keys".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/emulation/keys/prod.keys";

  home.file."${config.home.homeDirectory}/.local/share/suyu/nand/user/save".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/data/Games/Saves/Yuzu/save";

  home.file."${config.home.homeDirectory}/.local/share/suyu/load".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/data/Games/Mods/Yuzu";
}
