{pkgs, ...}: {
  home.packages = [
    pkgs.steam
    pkgs.armcord
  ];

  imports = [
    ../home.nix
  ];

  home.stateVersion = "24.05"; # Please read the comment before changing.
}
