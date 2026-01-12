{
  pkgs,
  pkgs_unstable,
  pkgs_citrix,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    # Portal for KDE Wayland screen sharing (must be in user profile)
    kdePackages.xdg-desktop-portal-kde

    # Desktop apps
    swww
    waybar
    vesktop # Discord client with Vencord (better Wayland support than legcord)
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
    vintagestory

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
  stylix.targets.firefox.firefoxGnomeTheme.enable = true; # Use Firefox GNOME theme with Stylix colors

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

  # Ensure KDE portal starts for Wayland screen sharing
  systemd.user.services.plasma-xdg-desktop-portal-kde = {
    Unit = {
      Description = "Portal service (KDE implementation)";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.impl.portal.desktop.kde";
      ExecStart = "${pkgs.kdePackages.xdg-desktop-portal-kde}/libexec/xdg-desktop-portal-kde";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
