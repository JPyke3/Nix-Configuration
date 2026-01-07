{
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # Desktop apps
    swaynotificationcenter
    swww
    waybar
    legcord
    runelite
    obsidian
    slack
    telegram-desktop
    vlc
    mpv
    dolphin

    # Gaming
    steam
    lutris
    heroic
    prismlauncher

    # Development
    vscode

    # Work
    citrix_workspace

    # Utilities
    bitwarden
    qbittorrent
  ];

  home.stateVersion = "25.11";

  # Override for Obsidian if needed
  nixpkgs.config.permittedInsecurePackages =
    lib.optional (pkgs.obsidian.version == "1.4.16") "electron-25.9.0"
    ++ lib.optional (pkgs.obsidian.version == "1.5.3") "electron-25.9.0";

  imports = [
    ../home.nix
    ../../../programs/desktop/hyprland.nix
    ../../../programs/desktop/waybar/main.nix
    ../../../programs/desktop/kitty/kitty.nix
  ];
}
