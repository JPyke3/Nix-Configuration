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
    inputs.hytale-launcher.packages.x86_64-linux.default

    # Development
    vscode

    # Work (uses pinned nixpkgs with webkitgtk_4_0)
    pkgs_citrix.citrix_workspace

    # Utilities
    bitwarden-desktop
    qbittorrent
  ];

  home.stateVersion = "25.11";

  # Add Flatpak exports to XDG_DATA_DIRS so apps appear in launchers
  xdg.systemDirs.data = [
    "/var/lib/flatpak/exports/share"
    "/home/jacobpyke/.local/share/flatpak/exports/share"
  ];

  # Stylix Firefox profile configuration
  stylix.targets.firefox.profileNames = ["default"];
  stylix.targets.firefox.firefoxGnomeTheme.enable = true; # Use Firefox GNOME theme with Stylix colors

  # Override for Obsidian if needed
  nixpkgs.config.permittedInsecurePackages =
    lib.optional (pkgs.obsidian.version == "1.4.16") "electron-25.9.0"
    ++ lib.optional (pkgs.obsidian.version == "1.5.3") "electron-25.9.0";

  imports = [
    ../home.nix
    ../../../users/jacob/common-home-desktop.nix
    ../../../programs/desktop/hyprland.nix
    ../../../programs/desktop/waybar/main.nix
    ../../../programs/desktop/kitty/kitty.nix
    ../../../programs/desktop/chrome.nix
  ];

  # Wrap HytaleClient to use NVIDIA GPU (runs after home-manager switch)
  home.activation.wrapHytaleClient = lib.hm.dag.entryAfter ["writeBoundary"] ''
        HYTALE_CLIENT="$HOME/.local/share/Hytale/install/release/package/game/latest/Client/HytaleClient"
        HYTALE_CLIENT_REAL="$HOME/.local/share/Hytale/install/release/package/game/latest/Client/HytaleClient.real"

        if [ -f "$HYTALE_CLIENT" ] && [ ! -L "$HYTALE_CLIENT" ]; then
          # Move original binary if not already wrapped
          if [ ! -f "$HYTALE_CLIENT_REAL" ]; then
            $DRY_RUN_CMD mv "$HYTALE_CLIENT" "$HYTALE_CLIENT_REAL"
          else
            # Game was updated, replace the .real file
            $DRY_RUN_CMD mv "$HYTALE_CLIENT" "$HYTALE_CLIENT_REAL"
          fi

          # Create wrapper script with NVIDIA PRIME offload
          $DRY_RUN_CMD cat > "$HYTALE_CLIENT" << 'WRAPPER'
    #!/usr/bin/env bash
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$(dirname "$0")/HytaleClient.real" "$@"
    WRAPPER
          $DRY_RUN_CMD chmod +x "$HYTALE_CLIENT"
        fi
  '';

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
