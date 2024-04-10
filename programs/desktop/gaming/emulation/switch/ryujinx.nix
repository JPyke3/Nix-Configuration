{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./secrets/prodkeys.nix
  ];

  home.packages = with pkgs; [
    ryujinx
  ];

  home.file."${config.home.homeDirectory}/.config/Ryujinx/system/prod.keys".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.local/emulation/keys/prod.keys";

  # Symlink to Syncthing Directory
  xdg.configFile."Ryujinx/bis/user/save".source = config.lib.file.mkOutOfStoreSymlink "/home/jacobpyke/data/Games/Saves/Ryujinx/save";
}
