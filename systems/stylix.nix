{pkgs, ...}: let
  fontSize =
    if pkgs.stdenv.isDarwin
    then 16
    else 10;
in {
  stylix.enable = true;

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
  stylix.image = ../wallpapers/nixos-wallpaper.png;

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
