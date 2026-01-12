{pkgs, ...}: let
  fontSize =
    if pkgs.stdenv.isDarwin
    then 16
    else 10;
in {
  stylix.enable = true;
  stylix.polarity = "dark"; # Force dark mode for KDE

  # Custom Outer Wilds theme - pure black for OLED, campfire warmth
  stylix.base16Scheme = {
    base00 = "000000"; # Pure black (OLED)
    base01 = "0a0f12"; # Dark charcoal
    base02 = "141a1e"; # Selection bg
    base03 = "3a4550"; # Comments - neutral slate
    base04 = "5a6570"; # Dark fg - neutral
    base05 = "c8cdd0"; # Main text - neutral
    base06 = "dce0e3"; # Light text - neutral
    base07 = "f0f2f4"; # Brightest - neutral
    base08 = "e86a50"; # Ember red
    base09 = "e88a30"; # Campfire orange
    base0A = "e8a045"; # Warm amber
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
