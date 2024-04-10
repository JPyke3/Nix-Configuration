{inputs, ...}: {
  environment.systemPackages = [
    inputs.jpyke3-suyu.packages.x86_64-linux.suyu-dev
  ];
}
