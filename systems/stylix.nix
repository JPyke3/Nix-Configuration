{pkgs, ...}: {
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";

  stylix.image = ../wallpapers/macos-wallpaper.png;

  stylix.fonts = {
    monospace = {
      package = pkgs.nerdfonts.override {fonts = ["FiraMono"];};
      name = "FiraMono Nerd Font";
    };
    sansSerif = {
      package = pkgs.noto-fonts-cjk;
      name = "Noto Sans CJK";
    };
    serif = {
      package = pkgs.noto-fonts-cjk;
      name = "Noto Serif CJK";
    };
  };
}
