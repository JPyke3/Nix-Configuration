{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs; [
    coreutils
    parallel
  ];

  users.users.jacobpyke = {
    name = "jacobpyke";
    home = "/Users/jacobpyke";
  };

  services.nix-daemon.enable = true;

  homebrew = {
    enable = true;
    brews = [
		"koekeishiya/formulae/yabai"
		"koekeishiya/formulae/skhd"
	];
    casks = [
      "nikitabobko/tap/aerospace"
      "steam"
      "crossover"
	  "tailscale"
	  "raycast"
	  "anki"
    ];
	masApps = {
		Infuse = 1136220934;
		"Timery for Toggl" = 1425368544;
	};
  };

  system.defaults = { 
  	# Dock Settings
  	dock = {
		autoHide = true;
		mineffect = "scale";
		orientation = "left";
		minimize-to-application = true;
		persistent-apps = [
			"${pkgs.firefox-bin}/Applications/Firefox.app"
			"${pkgs.kitty}/Applications/Kitty.app"
			"/Applications/Messages.app"
			"/Applications/System Settings.app"
		];
		show-recents = false;

		# Disable Hover actions
		wvous-bl-corner = "1";
		wvous-br-corner = "1";
		wvous-tl-corner = "1";
		wvous-tr-corner = "1";
	};
  };

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
