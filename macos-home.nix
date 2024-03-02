{
  config,
  pkgs,
  inputs,
  ...
}: let
  nix-colors = import <nix-colors> {};
in {
  home.username = "jacobpyke";
  home.homeDirectory = "/Users/jacobpyke";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
  	rectangle
  ];

  imports = [
    ./programs/zsh.nix
    ./programs/tmux.nix
    ./programs/alacritty.nix
    ./programs/git.nix
  ];

  nixpkgs.config.allowUnfree = true;
}
