{
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [
    ./mac-defaults.nix
    ../../programs/cli/homebrew.nix
    ../../programs/daemon/yabai.nix
    ../../programs/daemon/kanata/kanata.nix
    ../../programs/daemon/jellyfin-mpv-shim.nix
    ../../programs/daemon/tabby/tabby.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  nixpkgs.overlays = [
    inputs.nixpkgs-firefox-darwin.overlay
  ];

  environment.systemPackages = with pkgs; [
    coreutils
    parallel
    alejandra
    pipx
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    # Installation option once https://github.com/LnL7/nix-darwin/pull/942 is merged:
    # package = nh_darwin.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  users.users.jacobpyke = {
    name = "jacobpyke";
    home = "/Users/jacobpyke";
  };

  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
