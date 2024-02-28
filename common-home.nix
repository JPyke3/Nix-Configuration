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
    pkgs.git
    pkgs.gh
    pkgs.fzf
    pkgs.ripgrep
    pkgs.tldr
    pkgs.jq
    pkgs.fd
    pkgs.eza
    (import ./scripts/tmux-sessionizer.nix {inherit pkgs;})
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  nixpkgs.overlays = [
    inputs.nur.overlay
  ];

  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-medium;

  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.home-manager.enable = true;
}
