{
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.steam
    pkgs.armcord
  ];

  imports = [
    ../home.nix
    ../../../programs/desktop/firefox.nix
    ../../../programs/desktop/gaming/emulation/switch/suyu.nix
    ../../../programs/desktop/gaming/emulation/switch/ryujinx.nix
  ];

  home.stateVersion = "24.05"; # Please read the comment before changing.
}
