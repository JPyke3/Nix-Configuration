{
  inputs,
  system,
  ...
}: let
  pkgs_unstable = inputs.unstable.legacyPackages.${system};
in {
  environment.systemPackages = with pkgs_unstable; [
    nh
  ];
}
