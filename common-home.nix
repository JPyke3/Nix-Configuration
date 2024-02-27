{
  config,
  pkgs,
  inputs,
  system,
  ...
}: let
  nix-colors = import <nix-colors> {};
  pkgs_unstable = inputs.nixpkgs_unstable.legacyPackages.${system};
in {
  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.lf
    pkgs.neovim
    pkgs.aria
    pkgs.tmux
    pkgs.nodejs_20 # LTS and Needed for Copilot
    pkgs.direnv
	pkgs_unstable.alacritty
    pkgs.git
    pkgs.gh
    pkgs.fzf
    pkgs.ripgrep
    pkgs.tldr
    pkgs.jq
  ];

  disabledModules = [
	"programs/alacritty.nix"
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
