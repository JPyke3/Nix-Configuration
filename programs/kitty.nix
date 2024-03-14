{ pkgs, ... }: let
  fontSize =
    if pkgs.stdenv.isDarwin
    then 16
    else 10;
in {
	programs.kitty = {
		enable = true;
		font = {
			package = with pkgs; (nerdfonts.override {fonts = ["FiraMono"];});
			name = "FiraMono Nerd Font";
			size = fontSize;
		};
	};
}
