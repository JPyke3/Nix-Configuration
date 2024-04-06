{
  config,
  pkgs,
  sops,
  ...
}: {
  sops.secrets."programs/syncthing/guiusername" = {};
  sops.secrets."programs/syncthing/guipassword" = {};

  services = {
    syncthing = {
      enable = true;
      user = "jacobpyke";
      dataDir = "/home/jacobpyke/data";
      configDir = "/home/jacobpyke/.config/syncthing";
      extraFlags = [
        "--gui-user=$(cat /var/secrets/syncthing/guiusername)"
        "--gui-password=$(cat /var/secrets/syncthing/guipassword)"
      ];
    };
  };
}
