{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  nix-colors = import <nix-colors> {};
in {
  home.username = "jacobpyke";

  home.homeDirectory = "/home/jacobpyke";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.firefox-unwrapped
  ];

  home.activation.setupEtc = config.lib.dag.entryAfter ["writeBoundary"] ''
    /run/current-system/sw/bin/systemctl start --user sops-nix
  '';

  imports = [
    ../../users/jacob/common-home.nix
    ../../programs/desktop/firefox.nix
    ../../programs/desktop/kitty/kitty.nix
  ];
}
