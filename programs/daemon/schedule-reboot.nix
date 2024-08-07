{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.jpyke3.scheduleReboot;
in {
  options.jpyke3.cleanDownloadsFolder = {
    enable = lib.mkEnableOption "Enable a Scheduled Reboot";
    hour = "00";
    minute = "00";
    second = "00";
  };

  config = {
    systemd.timers.clean-downloads-folder = mkIf pkgs.stdenv.isLinux {
      description = "Schedule a reboot of the system";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*-*-* ${cfg.hour}:${cfg.minute}:${cfg.second}";
        Persistent = true;
        Unit = "reboot-machine.service";
      };
    };

    systemd.services.clean-downloads-folder = mkIf pkgs.stdenv.isLinux {
      description = "Schedule a reboot of the system";
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.toybox}/bin/reboot";
        user = "jacobpyke";
      };
    };

    launchd.agents.clean-downloads-folder = mkIf pkgs.stdenv.isDarwin {
      command = "${pkgs.toybox}/bin/reboot";
      serviceConfig = {
        RunAtLoad = true;
        StartCalendarInterval = {
          Hour = cfg.hour;
          Minute = cfg.minute;
        };
        StandardOutPath = "/Users/jacobpyke/.logs/clean-downloads-folder.log";
        StandardErrorPath = "/Users/jacobpyke/.logs/clean-downloads-folder.log";
      };
    };
  };
}
