{config, ...}: {
  launchd.user.agents.tabby = {
    command = "/opt/homebrew/bin/tabby serve --device metal --port 53435";
    serviceConfig = {
      UserName = "jacobpyke";
      StandardOutPath = "/Users/jacobpyke/.logs/tabby.out";
      StandardErrorPath = "/Users/jacobpyke/.logs/tabby.err";
      RunAtLoad = true;
    };
  };
}
