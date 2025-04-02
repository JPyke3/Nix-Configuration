{
  pkgs,
  config,
  ...
}: {
  home.packages = [
    pkgs.steam
    pkgs.legcord
    pkgs.moonlight-qt
    pkgs.owocr
  ];

  imports = [
    ../home.nix
    ../../../programs/desktop/firefox.nix
  ];

  home.stateVersion = "24.05"; # Please read the comment before changing.
}
