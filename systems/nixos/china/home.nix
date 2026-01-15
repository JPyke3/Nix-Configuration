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

  # Headless server - disable notification hooks
  jacob.claude-code.headless = true;

  home.stateVersion = "24.05"; # Please read the comment before changing.
}
