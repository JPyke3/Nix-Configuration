{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.hostPlatform = "aarch64-darwin";

  nixpkgs.overlays = [
    inputs.nixpkgs-firefox-darwin.overlay
  ];

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
			autohide = true;
			mineffect = "scale";
			orientation = "left";
			minimize-to-application = true;
			persistent-apps = [
				"/Users/jacobpyke/Applications/Home Manager Apps/Firefox.app"
				"/Users/jacobpyke/Applications/Home Manager Apps/Kitty.app"
				"/System/Applications/Messages.app"
				"/System/Applications/System Settings.app"
			];
			show-recents = false;

			# Disable Hover actions
			wvous-bl-corner = 1;
			wvous-br-corner = 1;
			wvous-tl-corner = 1;
			wvous-tr-corner = 1;
		};
	};

	  system.activationScripts.postUserActivation.text = ''
    # Following line should allow us to avoid a logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';

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
