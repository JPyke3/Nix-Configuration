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

  xdg.configFile."Ryujinx/bis/user/save" = config.lib.file.mkOutOfStoreSymlink "/home/jacobpyke/data/Games/Saves/Ryujinx/save";
}
