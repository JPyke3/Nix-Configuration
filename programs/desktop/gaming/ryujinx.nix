{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    ryujinx
  ];

  sops.secrets."emulation/switch" = {
    path = "${config.home.homeDirectory}/.config/Ryujinx/system/prod.keys";
  };

  # Symlink to Syncthing Directory
  xdg.configFile."Ryujinx/bis/user/save".source = config.lib.file.mkOutOfStoreSymlink "/home/jacobpyke/data/Games/Saves/Ryujinx/save";
}
