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
    pkgs.direnv
    pkgs.git
    pkgs.gh
    pkgs.fzf
    pkgs.ripgrep
    pkgs.tldr
    pkgs.jq
    pkgs.fd
    pkgs.eza
    pkgs.spotify-player
    pkgs.sops
    (import ../../scripts/tmux-sessionizer.nix {inherit pkgs;})
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
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets = {
      "llms/openai_api_key" = {};
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  accounts.email.accounts = {
    carex = {
      address = "jacob@carex.life";
      primary = true;
      neomutt = {
        enable = true;
      };
    };
  };
}
