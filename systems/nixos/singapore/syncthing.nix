{...}: {
  # Syncthing Folders
  imports = with ../../../programs/daemon/syncthing/folders; [
    /documents.nix
    /downloads.nix
    /gamesaves.nix
    /gameroms.nix
    /gamefirmware.nix
  ];
}
