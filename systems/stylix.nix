{pkgs, ...}: let
  fontSize =
    if pkgs.stdenv.isDarwin
    then 16
    else 10;
in {
  stylix.enable = true;
  stylix.polarity = "dark"; # Force dark mode for KDE

  # Custom Outer Wilds theme - YAML file with variant: dark metadata
  stylix.base16Scheme = ../themes/outer-wilds.yaml;
  stylix.image = ../wallpapers/outer-wilds.png;

  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.fira-mono;
      name = "FiraMono Nerd Font";
    };
    sansSerif = {
      package = pkgs.noto-fonts-cjk-sans;
      name = "Noto Sans CJK";
    };
    serif = {
      package = pkgs.noto-fonts-cjk-sans;
      name = "Noto Serif CJK";
    };
    sizes = {
      applications = 11;
      desktop = 10;
      terminal = fontSize;
      popups = 10;
    };
  };
}
