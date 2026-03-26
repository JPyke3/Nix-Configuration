{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.inir.homeModules.default
  ];

  programs.inir.enable = true;

  # Override Stylix's Adwaita icon theme (has no app icons) with Papirus-Dark
  home.activation.fixIconTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -f "$HOME/.config/kdeglobals" ]; then
      ${pkgs.gnused}/bin/sed -i 's/^Theme=Adwaita/Theme=Papirus-Dark/' "$HOME/.config/kdeglobals" 2>/dev/null || true
    fi
  '';
}
