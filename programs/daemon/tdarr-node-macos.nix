{config, ...}: {
  launchd.user.agents.tabby = {
    command = "/Users/jacobpyke/Development/Tdarr/Tdarr_Node/Tdarr_Node";
    serviceConfig = {
      UserName = "jacobpyke";
      StandardOutPath = "/Users/jacobpyke/.logs/tdarr_node.out";
      StandardErrorPath = "/Users/jacobpyke/.logs/tdarr_node.err";
      RunAtLoad = true;
    };
  };
}
