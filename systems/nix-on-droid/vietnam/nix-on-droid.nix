{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  # System state version for nix-on-droid
  system.stateVersion = "24.05";

  # Timezone (Brisbane, Australia)
  time.timeZone = "Australia/Brisbane";

  # Nix settings
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Android integration utilities
  android-integration = {
    termux-open.enable = true;
    termux-open-url.enable = true;
    termux-setup-storage.enable = true;
    termux-wake-lock.enable = true;
    termux-wake-unlock.enable = true;
    xdg-open.enable = true; # Alias xdg-open to termux-open
  };

  # User configuration
  user.shell = "${pkgs.zsh}/bin/zsh";

  # Environment packages (system-level for nix-on-droid)
  environment.packages = with pkgs; [
    # Core tools from plan
    inputs.claude-code.packages.aarch64-linux.default
    zellij
    mosh

    # Development
    git
    git-lfs
    gh
    neovim

    # Utilities
    fastfetch
    syncthing
    ripgrep
    fd
    eza
    fzf
    jq
    htop

    # Mobile shell support
    openssh
  ];

  # Environment variables
  environment.sessionVariables = {
    EDITOR = "nvim";
    COLORTERM = "truecolor";
  };

  # Home-manager integration (built into nix-on-droid)
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    config = ./home.nix;
    extraSpecialArgs = {inherit inputs;};
  };
}
