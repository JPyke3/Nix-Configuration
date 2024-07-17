{...}: {
  services.gitea = {
    enable = true;
	stateDir = "/mypool/git/gitea"
  };
}
