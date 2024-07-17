{
  pkgs,
  inputs,
  ...
} @ args: {
  nixpkgs.overlays = [inputs.immich];

  imports = [
    "${args.inputs.immich}/nixos/modules/services/web-apps/immich.nix"
  ];

  services.immich = {
    enable = true;
  };
}
