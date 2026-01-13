{
  pkgs,
  config,
  inputs,
  ...
}: {
  home.packages = [
    pkgs.steam
    pkgs.legcord
    pkgs.moonlight-qt
    pkgs.owocr
    inputs.hytale-launcher.packages.x86_64-linux.default
  ];

  imports = [
    ../home.nix
    ../../../users/jacob/common-home-desktop.nix
    ../../../programs/desktop/firefox.nix
  ];

  home.stateVersion = "24.05"; # Please read the comment before changing.
}
