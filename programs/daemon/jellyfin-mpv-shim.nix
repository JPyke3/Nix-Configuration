{...}: {
  launchd.agents.jellyfinmpvshim = {
    command = "/usr/bin/python3 /Users/jacobpyke/Library/Python/3.9/bin/jellyfin-mpv-shim";
    serviceConfig = {
      UserName = "jacobpyke";
      KeepAlive = true;
      RunAtLoad = true;
      StandardErrorPath = "/tmp/jellyfin-mpv-shim.err";
      StandardOutPath = "/tmp/jellyfin-mpv-shim.out";
      ProcessType = "Interactive";
    };
  };
}
