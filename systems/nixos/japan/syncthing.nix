{...}: {
  # Syncthing Folders
  imports = [
    ../../../programs/daemon/syncthing/folders/gamesaves.nix
    ../../../programs/daemon/syncthing/folders/gameroms.nix
    ../../../programs/daemon/syncthing/folders/gamefirmware.nix
    ../../../programs/daemon/syncthing/folders/gamesteamgrids.nix
  ];
}
