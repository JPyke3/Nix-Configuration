{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.jpyke3.cleanDownloadsFolder;
in {
  options.jpyke3.cleanDownloadsFolder = {
    enable = lib.mkEnableOption "Enable the clean downloads folder service";
  };

  config = {
    systemd.timers.clean-downloads-folder = mkIf pkgs.stdenv.isLinux {
      description = "Clean up downloads directory";
      wantedBy = ["timers.target"];
      after = ["network.target"];
      timerConfig = {
        OnCalendar = "*-*-* 00:00:00";
        Persistent = true;
        Unit = "clean-downloads-folder.service";
      };
    };

    systemd.services.clean-downloads-folder = mkIf pkgs.stdenv.isLinux {
      description = "Clean up downloads directory";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "/home/jacobpyke/.nix-profile/bin/clean-downloads-folder";
        user = "jacobpyke";
      };
    };

    launchd.agents.clean-downloads-folder = mkIf pkgs.stdenv.isDarwin {
      command = "/Users/jacobpyke/.nix-profile/bin/clean-downloads-folder";
      serviceConfig = {
        RunAtLoad = true;
        StartInterval = 86400;
        StandardOutPath = "/Users/jacobpyke/.logs/clean-downloads-folder.log";
        StandardErrorPath = "/Users/jacobpyke/.logs/clean-downloads-folder.log";
      };
    };
  };
}
