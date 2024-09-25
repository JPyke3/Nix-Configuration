{
  pkgs,
  config,
  ...
}: {
  home.packages = [
  ];

  imports = [
    ../home.nix
  ];

  home.stateVersion = "24.05"; # Please read the comment before changing.
}
