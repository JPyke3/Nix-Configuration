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
    pkgs.fcitx5-configtool
  ];

  #  home.activation.setupEtc = config.lib.dag.entryAfter ["writeBoundary"] ''
  #    /run/current-system/sw/bin/systemctl start --user sops-nix
  #  '';

  home.file."Development".source = config.lib.file.mkOutOfStoreSymlink "/home/jacobpyke/data/Development";
  home.file."Documents".source = config.lib.file.mkOutOfStoreSymlink "/home/jacobpyke/data/Documents";
  home.file."Downloads".source = config.lib.file.mkOutOfStoreSymlink "/home/jacobpyke/data/Downloads";

  imports = [
    ../../users/jacob/common-home.nix
    ../../programs/desktop/firefox.nix
    ../../programs/desktop/chrome.nix
    ../../programs/desktop/kitty/kitty.nix
  ];
}
