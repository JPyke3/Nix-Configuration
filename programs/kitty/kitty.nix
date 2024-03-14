{ pkgs, config, ... }: let
  fontSize =
    if pkgs.stdenv.isDarwin
    then 16
    else 10;
in {
	xdg.configFile."kitty/themes/JacobsTheme.conf".text = import ./Jacobs-Theme.nix {inherit config;};
	programs.kitty = {
		enable = true;
		font = {
			package = with pkgs; (nerdfonts.override {fonts = ["FiraMono"];});
			name = "FiraMono Nerd Font";
			size = fontSize;
		};
		settings = {
			theme = "Jacobs Nix Theme";
		};
		shellIntegration.enableZshIntegration = true;
	};
}
