{
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [
    ./mac-defaults.nix
    ../../programs/cli/homebrew.nix
    ../../programs/daemon/yabai.nix
    ../../programs/daemon/kanata/kanata.nix
    ../../programs/daemon/jellyfin-mpv-shim.nix
    ../../programs/daemon/tabby/tabby.nix

	# TODO: Add
	# ../../programs/daemon/download-cleaner.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  nixpkgs.overlays = [
    inputs.nixpkgs-firefox-darwin.overlay
  ];

  environment.systemPackages = with pkgs; [
    coreutils
    parallel
    alejandra
    pipx
  ];

  users.users.jacobpyke = {
    name = "jacobpyke";
    home = "/Users/jacobpyke";
  };

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
