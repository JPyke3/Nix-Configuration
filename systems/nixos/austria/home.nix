{
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = [
    pkgs.swaynotificationcenter
    pkgs.swww
    pkgs.waybar
    pkgs.legcord
    pkgs.obsidian
    pkgs.anki
    pkgs.vlc
    pkgs.mpv
    pkgs.jellyfin-mpv-shim
  ];

  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Override for Obisidian, Electron 25 is EOL
  nixpkgs.config.permittedInsecurePackages = lib.optional (pkgs.obsidian.version == "1.4.16") "electron-25.9.0";

  imports = [
    ../home.nix
    ../../../programs/desktop/hyprland.nix
    ../../../programs/desktop/waybar/main.nix
  ];
}
