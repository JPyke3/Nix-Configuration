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
    pkgs.steam
    pkgs.armcord
    pkgs.runelite
    pkgs.obsidian
    pkgs.texliveFull
    pkgs.slack
    pkgs.jellyfin-mpv-shim
    pkgs.telegram
    # inputs.llama-cpp.packages.x86_64-linux.rocm
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
