{inputs, ...}: {
  environment.systemPackages = [
    inputs.jpyke3-suyu.suyu-dev
  ];
}
