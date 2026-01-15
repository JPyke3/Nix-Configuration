{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ../../../users/jacob/common-home.nix
  ];

  home.stateVersion = "24.05";

  # Mobile device - disable notification hooks
  jacob.claude-code.mobile = true;

  # Manual Syncthing control (no systemd on nix-on-droid)
  programs.zsh.shellAliases = {
    sync-start = "syncthing serve --no-browser > ~/.syncthing.log 2>&1 &";
    sync-stop = "pkill syncthing";
    sync-status = "pgrep -a syncthing";
  };
}
