{inputs, ...}: {
  environment.systemPackages = [
    inputs.jpyke3-suyu.packages.x86_64-linux.suyu-dev
  ];

  sops.secrets."emulation/switch" = {
    path = "${config.home.homeDirectory}/.local/share/suyu/keys/prod.keys";
  };
}
