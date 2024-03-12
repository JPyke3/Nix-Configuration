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
    pkgs.swaynotificationcenter
    pkgs.swww
    pkgs.firefox-unwrapped
    pkgs.waybar
    pkgs.steam
    pkgs.armcord
    pkgs.runelite
    pkgs.obsidian
    inputs.llama-cpp.rocm
  ];

  # Override for Obisidian, Electron 25 is EOL
  nixpkgs.config.permittedInsecurePackages = lib.optional (pkgs.obsidian.version == "1.4.16") "electron-25.9.0";

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  imports = [
    ./programs/firefox.nix
    ./programs/hyprland.nix
    ./programs/waybar/main.nix
    ./programs/zsh.nix
    ./programs/tmux.nix
    ./programs/alacritty.nix
    ./programs/git.nix
    ./programs/nvim/nvim.nix
    ./programs/alacritty.nix
  ];
}
