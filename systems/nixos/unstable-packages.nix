{
  inputs,
  pkgs,
  ...
}: let
  pkgs_unstable = import inputs.unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
  environment.systemPackages = with pkgs_unstable; [
    hyprlock
    claude-code
  ];
}
