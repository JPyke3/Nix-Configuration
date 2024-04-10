{
  inputs,
  config,
  ...
}: {
  home.packages = [
    inputs.jpyke3-suyu.suyu-dev
  ];

  sops.secrets."emulation/switch" = {
    path = "${config.home.homeDirectory}/.local/share/suyu/keys/prod.keys";
  };
}
