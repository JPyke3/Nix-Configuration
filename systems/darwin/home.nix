{
  config,
  pkgs,
  inputs,
  ...
}: let
  nix-colors = import <nix-colors> {};
in {
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    rectangle
    darwin.apple_sdk.frameworks.Foundation
    mpv
    slack
    spotify
  ];

  nixpkgs.overlays = [
    inputs.nixpkgs-firefox-darwin.overlay
  ];

  programs.zsh.initExtra = ''
    #make sure brew is on the path for M1
    if [[ $(uname -m) == 'arm64' ]]; then
    	 eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  '';

  imports = [
    ../../users/jacob/common-home.nix
    ../../programs/desktop/alacritty.nix
    ../../programs/desktop/firefox.nix
    ../../programs/desktop/kitty/kitty.nix
    ../../programs/daemon/sketchybar/plugins.nix
  ];

  services.syncthing = {
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;
}
