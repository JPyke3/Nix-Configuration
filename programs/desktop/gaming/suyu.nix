{config, ...}: {
  environment.systemPackages = [
    config.nur.repos.chigyutendies.suyu
  ];
}
