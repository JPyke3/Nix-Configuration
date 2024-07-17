{pkgs, outputs, ...} @ args: {

  nixpkgs.overlays = [ outputs.immich ]

  imports = [
    "${args.inputs.immich}/nixos/modules/services/web-apps/immich.nix"
  ];

  services.immich = {
    enable = true;
  };
}
