{
  config,
  pkgs,
  inputs,
  lib,
  isNixOnDroid ? false, # Flag passed from nix-on-droid to disable incompatible options
  ...
}: {
  # These options conflict with useGlobalPkgs in nix-on-droid
  nixpkgs.config.allowUnfree = lib.mkIf (!isNixOnDroid) true;

  home.packages =
    [
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
    ]
    # GUI packages - not available on nix-on-droid
    ++ lib.optionals (!isNixOnDroid) [
      pkgs.spotify-player
      pkgs.zathura
      pkgs.gimp
    ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Overlays conflict with useGlobalPkgs in nix-on-droid
  nixpkgs.overlays = lib.mkIf (!isNixOnDroid) [
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
  ];

  # SOPS secrets - disabled on nix-on-droid (no age key setup)
  sops = lib.mkIf (!isNixOnDroid) {
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
