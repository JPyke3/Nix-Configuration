{
  config,
  pkgs,
  inputs,
  ...
}: let
  pkgs_unstable = inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  fontSize =
    if pkgs.stdenv.isDarwin
    then 16
    else 10;
in {
  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraMono"];})
  ];
  fonts.fontconfig.enable = true;
  programs.alacritty = {
    enable = true;
    settings = {
      font.size = fontSize;
      font.normal.family = "FiraMono Nerd Font";
      env.TERM = "xterm-256color";
      colors = with config.lib.stylix.colors; {
        bright = {
          black = "0x${base00}";
          blue = "0x${base0D}";
          cyan = "0x${base0C}";
          green = "0x${base0B}";
          magenta = "0x${base0E}";
          red = "0x${base08}";
          white = "0x${base06}";
          yellow = "0x${base09}";
        };
        cursor = {
          cursor = "0x${base06}";
          text = "0x${base06}";
        };
        normal = {
          black = "0x${base00}";
          blue = "0x${base0D}";
          cyan = "0x${base0C}";
          green = "0x${base0B}";
          magenta = "0x${base0E}";
          red = "0x${base08}";
          white = "0x${base06}";
          yellow = "0x${base0A}";
        };
        primary = {
          background = "0x${base00}";
          foreground = "0x${base06}";
        };
      };
    };
  };
}
