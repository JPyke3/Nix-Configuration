{
  inputs,
  nixpkgs,
  ...
}: let
  pkgs_unstable = inputs.unstable.legacyPackages.${nixpkgs.lib.nixosSystem.system};
in {
  environment.systemPackages = with pkgs_unstable; [
    nh
  ];
}
