{ pkgs, ... }:
{
  	home.packages = with pkgs; [
   		 (nerdfonts.override {fonts = ["FiraMono"];})
	];
	programs.kitty = {
		enable = true;
		font = "FiraMono Nerd Font";
	};
}
