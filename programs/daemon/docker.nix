{...}: {
  virtualisation.docker.enable = true;
  users.users.jacobpyke.extraGroups = ["docker"];
}
