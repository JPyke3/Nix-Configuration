{
  inputs,
  pkgs,
  ...
}: let
  pkgs_unstable = import inputs.unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
  claude-code = inputs.claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  environment.systemPackages = with pkgs_unstable; [
    hyprlock
    claude-code
  ];
}
