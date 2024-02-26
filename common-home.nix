{
  config,
  pkgs,
  inputs,
  ...
}: let
  nix-colors = import <nix-colors> {};
in {
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
    pkgs.fzf
    pkgs.ripgrep
    pkgs.tldr
    pkgs.jq
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  nixpkgs.overlays = [
    inputs.nur.overlay
  ];

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-hard;

  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  imports = [
    ./programs/zsh.nix
    ./programs/tmux.nix
    ./programs/alacritty.nix
    ./programs/git.nix
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.home-manager.enable = true;
}
