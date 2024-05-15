{ lib, ... }:
{
  home.packages = [
	(import ../../scripts/delete-downloads.nix {inherit pkgs;})
  ];

  systemd.timers.clean-downloads-folder = lib.mkIf stdenv.isLinux {
	description = "Clean up downloads directory";
	wantedBy = [ "timers.target" ];
	after = [ "network.target" ];
	timerConfig = {
	  OnCalendar = "*-*-* 00:00:00";
	  Persistent = true;
	  Unit = "clean-downloads-folder.service";
	};
  };

  systemd.services.clean-downloads-folder = lib.mkIf stdenv.isLinux {
    description = "Clean up downloads directory";
	wantedBy = [ "multi-user.target" ];
	after = [ "network.target" ];
	serviceConfig = {
		Type = "oneshot";
		ExecStart = "/home/jacobpyke/.nix-profile/bin/clean-downloads-folder";
		user = "jacobpyke";
	};
  };

  launchd.user.agents.clean-downloads-folder = lib.mkIf stdenv.isDarwin {
  command = "/Users/jacobpyke/.nix-profile/bin/clean-downloads-folder";
  serviceConfig = {
	RunAtLoad = true;
	StartInterval = 86400;
	StandardOutPath = "/Users/jacobpyke/.logs/clean-downloads-folder.log";
	StandardErrorPath = "/Users/jacobpyke/.logs/clean-downloads-folder.log";
  };
}
