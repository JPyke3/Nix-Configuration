{inputs, ...}: {
  environment.systemPackages = [
    inputs.jpyke3-suyu.packages.suyu-dev
  ];
}
