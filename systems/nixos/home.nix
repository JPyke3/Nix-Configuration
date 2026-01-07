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

  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.firefox-unwrapped
  ];

  # Japanese Language Support
  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = [
    pkgs.fcitx5-mozc
    pkgs.fcitx5-gtk
    pkgs.qt6Packages.fcitx5-configtool
  ];

  #  home.activation.setupEtc = config.lib.dag.entryAfter ["writeBoundary"] ''
  #    /run/current-system/sw/bin/systemctl start --user sops-nix
  #  '';

  home.file = builtins.foldl' (
    acc: name:
      acc
      // lib.optionalAttrs (builtins.pathExists "/home/jacobpyke/data/${name}") {
        "${name}".source = config.lib.file.mkOutOfStoreSymlink "/home/jacobpyke/data/${name}";
      }
  ) {} ["Development" "Documents" "Downloads"];

  imports = [
    ../../users/jacob/common-home.nix
    ../../programs/desktop/firefox.nix
    ../../programs/desktop/kitty/kitty.nix
  ];
}
