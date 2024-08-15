{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.jpyke3.scheduleReboot;
in {
  options.jpyke3.scheduleReboot = {
    enable = mkEnableOption "Enable a Scheduled Reboot";
    hour = mkOption {
      type = types.str;
      default = "00";
      description = "Hour to schedule the reboot";
    };
    minute = mkOption {
      type = types.str;
      default = "00";
      description = "Minute to schedule the reboot";
    };
    second = mkOption {
      type = types.str;
      default = "00";
      description = "Second to schedule the reboot";
    };
  };

  config = mkIf cfg.enable {
    systemd.timers.reboot-machine = {
      description = "Schedule a reboot of the system";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*-*-* ${cfg.hour}:${cfg.minute}:${cfg.second}";
        Persistent = true;
        Unit = "reboot-machine.service";
      };
    };

    systemd.services.reboot-machine = {
      description = "Reboot the system";
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.systemd}/bin/systemctl reboot";
      };
    };
  };
}
