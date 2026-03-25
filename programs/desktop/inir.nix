{
  pkgs,
  inputs,
  ...
}: let
  inir = inputs.inir.packages.${pkgs.system}.default;
in {
  home.packages = with pkgs; [
    inir

    # Fonts iNiR expects
    material-symbols
    nerd-fonts.jetbrains-mono
    noto-fonts-color-emoji

    # Icon themes
    papirus-icon-theme
    adw-gtk3
    hicolor-icon-theme
    kdePackages.breeze-icons

    # Cursor theme
    capitaine-cursors

    # Qt theming
    qt6Packages.qtstyleplugin-kvantum

    # Runtime tools
    cliphist
    wl-clipboard
    brightnessctl
    matugen
    fuzzel
    grim
    slurp
    playerctl
    imagemagick
    swayidle
  ];

  # Symlink shell source so Quickshell can find it via `qs -c ii`
  # Read-only is fine — iNiR stores mutable state in XDG_STATE_HOME/XDG_CACHE_HOME
  xdg.configFile."quickshell/ii".source = "${inir}/share/inir";
}
