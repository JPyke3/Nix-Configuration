{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  nix-colors = import <nix-colors> {};
in {
  home.username = "jacobpyke";

  home.homeDirectory = "/home/jacobpyke";

  nixpkgs.config.allowUnfree = true;

  home.packages = [
    pkgs.firefox-unwrapped
  ];

  # Japanese Language Support
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = [
      pkgs.fcitx5-mozc
      pkgs.fcitx5-gtk
      pkgs.qt6Packages.fcitx5-configtool
    ];
  };

  #  home.activation.setupEtc = config.lib.dag.entryAfter ["writeBoundary"] ''
  #    /run/current-system/sw/bin/systemctl start --user sops-nix
  #  '';

  home.file = builtins.foldl' (
    acc: name:
      acc
      // lib.optionalAttrs (builtins.pathExists "/home/jacobpyke/data/${name}") {
        "${name}".source = config.lib.file.mkOutOfStoreSymlink "/home/jacobpyke/data/${name}";
      }
  ) {} ["Development" "Documents" "Downloads"];

  imports = [
    ../../users/jacob/common-home.nix
    ../../programs/desktop/firefox.nix
    ../../programs/desktop/kitty/kitty.nix
  ];

  # Downloads cleanup - delete files older than 30 days weekly
  systemd.user.services.clean-downloads = {
    Unit.Description = "Clean old files from Downloads folder";
    Service = {
      Type = "oneshot";
      ExecStart = toString (pkgs.writeShellScript "clean-downloads" ''
        DOWNLOADS="$HOME/Downloads"
        if [ -d "$DOWNLOADS" ]; then
          ${pkgs.findutils}/bin/find "$DOWNLOADS" -type f \
            -not -path "*/.stfolder/*" \
            -not -path "*/.stignore/*" \
            -mtime +30 -delete
          ${pkgs.findutils}/bin/find "$DOWNLOADS" -type d -empty -delete 2>/dev/null || true
        fi
      '');
    };
  };

  systemd.user.timers.clean-downloads = {
    Unit.Description = "Weekly cleanup of Downloads folder";
    Timer = {
      OnCalendar = "Sun *-*-* 00:00:00";
      Persistent = true;
    };
    Install.WantedBy = ["timers.target"];
  };
}
