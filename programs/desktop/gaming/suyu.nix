{config, ...}: {
  environment.systemPackages = [
    config.nur.repos.chigyutendies.pkgs.suyu
  ];
}
