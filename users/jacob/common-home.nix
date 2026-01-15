{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  # CLI packages - works on all platforms (NixOS, Darwin, Nix-on-Droid, headless servers)
  home.packages = [
    pkgs.lf
    pkgs.neovim
    pkgs.tmux
    pkgs.direnv
    pkgs.git
    pkgs.git-lfs
    pkgs.gh
    pkgs.fzf
    pkgs.ripgrep
    pkgs.tldr
    pkgs.jq
    pkgs.fd
    pkgs.eza
    pkgs.sops
    pkgs.nodejs_20
    pkgs.cargo
    pkgs.rustc
    (import ../../scripts/tmux-sessionizer.nix {inherit pkgs;})
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  nixpkgs.overlays = [
    inputs.nur.overlays.default
  ];

  imports = [
    inputs.sops-nix.homeManagerModules.sops

    ../../programs/cli/zsh.nix
    ../../programs/cli/tmux.nix
    ../../programs/cli/git.nix
    ../../programs/cli/nvim/nvim.nix
    ../../programs/cli/lf.nix
    ../../programs/cli/nix-index.nix
    ../../programs/cli/aria2.nix
    ../../programs/cli/zellij.nix
    ../../programs/cli/mosh.nix
    ../../programs/cli/fastfetch.nix
    ../../programs/cli/claude-code/claude-code.nix
  ];

  # Enable Claude Code with Nix-managed configuration
  jacob.claude-code.enable = true;

  # SOPS secrets
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets = {
      "llms/openai_api_key" = {
        path = "${config.home.homeDirectory}/.secrets/llms/openai_api_key";
      };
      "programs/up/accesskey" = {
        path = "${config.home.homeDirectory}/.secrets/up/accesskey";
      };
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
