{pkgs, ...}: let
  fontSize =
    if pkgs.stdenv.isDarwin
    then 16
    else 10;
in {
  stylix.enable = true;

  # Custom Outer Wilds theme - pure black for OLED, campfire warmth
  stylix.base16Scheme = {
    base00 = "000000"; # Pure black (OLED)
    base01 = "0d1a1d"; # Dark atmosphere
    base02 = "1a3338"; # Forest silhouette
    base03 = "3d5a5e"; # Teal mist (comments)
    base04 = "5a7a7e"; # Medium teal
    base05 = "c5d5d8"; # Main text
    base06 = "dae8ea"; # Light text
    base07 = "f0f8f9"; # Brightest
    base08 = "e86a50"; # Ember red
    base09 = "ea8c38"; # Campfire orange
    base0A = "f5b83a"; # Golden sparks
    base0B = "7ec98a"; # Forest green
    base0C = "4fbdbd"; # Atmosphere cyan
    base0D = "6ab8d4"; # Sky blue
    base0E = "b48ead"; # Twilight purple
    base0F = "c27d5a"; # Wood brown
  };
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
