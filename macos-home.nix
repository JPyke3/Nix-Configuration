{
  config,
  pkgs,
  inputs,
  ...
}: let
  nix-colors = import <nix-colors> {};
in {
  home.username = "jacobpyke"
  home.homeDirectory = "/Users/jacobpyke"

  home.stateVersion = "23.11"

  nixpkgs.config.allowUnfree = true;

}
