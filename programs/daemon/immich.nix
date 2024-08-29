{inputs, ...}: {
  imports = [
    "${inputs.immich}/nixos/modules/services/web-apps/immich.nix"
  ];

  services.immich = {
    enable = true;
  };
}
