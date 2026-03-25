{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.noctalia-shell.homeModules.default];

  programs.noctalia-shell = {
    enable = true;
    package = inputs.noctalia-shell.packages.${pkgs.system}.default;
    systemd.enable = false; # Started by niri spawn-at-startup instead
    settings = {}; # Use Noctalia's built-in settings UI initially
  };

  # Dependencies for Noctalia features
  home.packages = with pkgs; [
    brightnessctl
    cliphist
    imagemagick
    wl-clipboard
  ];
}
