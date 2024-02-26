{
  config,
  pkgs,
  inputs,
  ...
}: let
  nix-colors = import <nix-colors> {};
in {
  home.username = "jacobpyke";
  home.homeDirectory = "/home/jacobpyke";

  home.stateVersion = "23.11"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.lf
    pkgs.neovim
    pkgs.aria
    pkgs.tmux
    pkgs.nodejs_20 # LTS and Needed for Copilot
    pkgs.direnv
    pkgs.alacritty
    pkgs.git
    pkgs.gh
    pkgs.waybar
    pkgs.fzf
    pkgs.firefox-unwrapped
    pkgs.ripgrep
    pkgs.swww
    pkgs.swaynotificationcenter
    pkgs.tldr

    # Non-Essential Software
    pkgs.steam
    pkgs.armcord
    pkgs.runelite
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  nixpkgs.overlays = [
    inputs.nur.overlay
  ];

  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./programs/firefox.nix
    ./programs/zsh.nix
    ./programs/tmux.nix
    ./programs/hyprland.nix
    ./programs/alacritty.nix
    ./programs/waybar/main.nix
    ./programs/git.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-hard;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.home-manager.enable = true;
}
