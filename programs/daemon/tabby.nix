{ ... }:
{
    launchd.daemons.kmonad-default.serviceConfig = {
      KeepAlive = true;
      ProgramArguments = [
        "/opt/homebrew/bin/tabby"
        "serve"
		"--device"
		"metal"
      ];
      StandardOutPath = "/Library/Logs/Tabby/default-stdout";
      StandardErrorPath = "/Library/Logs/Tabby/default-stderr";
      RunAtLoad = true;
    };
}
