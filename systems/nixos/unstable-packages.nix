{
  inputs,
  pkgs,
  ...
}: let
  pkgs_unstable = inputs.unstable.legacyPackages.${pkgs.system};
in {
  environment.systemPackages = with pkgs_unstable; [
    nh
  ];
}
