{...}: {
  launchd.user.agents.jellyfinmpvshim = {
    command = "/usr/bin/python3 /Users/jacobpyke/Library/Python/3.9/bin/jellyfin-mpv-shim";
    serviceConfig = {
      UserName = "jacobpyke";
      KeepAlive = true;
      RunAtLoad = true;
      StandardErrorPath = "/Users/jacobpyke/.logs/jellyfin-mpv-shim.err";
      StandardOutPath = "/Users/jacobpyke/.logs/jellyfin-mpv-shim.out";
      ProcessType = "Interactive";
    };
  };
}
