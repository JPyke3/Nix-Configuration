{...}: {
  # Syncthing Folders
  imports = [
    ../../../programs/daemon/syncthing/folders/documents.nix
    ../../../programs/daemon/syncthing/folders/downloads.nix
    ../../../programs/daemon/syncthing/folders/development.nix
    ../../../programs/daemon/syncthing/folders/gamesaves.nix
    ../../../programs/daemon/syncthing/folders/gameroms.nix
    ../../../programs/daemon/syncthing/folders/gameroms-mobile.nix
    ../../../programs/daemon/syncthing/folders/gamemods.nix
    ../../../programs/daemon/syncthing/folders/gamefirmware.nix
    ../../../programs/daemon/syncthing/folders/gamesteamgrids.nix
  ];
}
