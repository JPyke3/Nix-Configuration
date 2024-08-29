{
  inputs,
  pkgs,
  config,
  ...
}: let
  immichPkgs = import inputs.immich {
    system = pkgs.system;
    config = config.nixpkgs.config;
  };
in {
  imports = [
    "${inputs.immich}/nixos/modules/services/web-apps/immich.nix"
  ];

  nixpkgs.overlays = [
    (final: prev: {
      immich = immichPkgs.immich;
    })
  ];

  services.immich = {
    enable = true;
    machine-learning.enable = false;
	host = "127.0.0.1"
  };
}
