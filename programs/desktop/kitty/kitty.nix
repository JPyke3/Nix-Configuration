{
  pkgs,
  config,
  ...
}: let
  fontSize =
    if pkgs.stdenv.isDarwin
    then 16
    else 10;
in {
  programs.kitty = {
    enable = true;
    shellIntegration.enableZshIntegration = true;
  };
  font.size = fontSize;
}
