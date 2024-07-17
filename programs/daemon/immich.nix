{pkgs, ...} @ args: {
  imports = [
    "${args.inputs.immich}/services/web-apps/immich.nix"
  ];

  services.immich = {
    enable = true;
  };
}
