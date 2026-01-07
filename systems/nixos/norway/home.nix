{
  pkgs,
  pkgs_unstable,
  pkgs_citrix,
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
    kdePackages.dolphin

    # Gaming
    steam
    lutris
    heroic
    prismlauncher

    # Development
    vscode

    # Work (uses pinned nixpkgs with webkitgtk_4_0)
    pkgs_citrix.citrix_workspace

    # Utilities
    bitwarden-desktop
    qbittorrent
  ];

  home.stateVersion = "25.11";

  # Stylix Firefox profile configuration
  stylix.targets.firefox.profileNames = ["default"];

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
