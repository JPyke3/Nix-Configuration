{inputs, ...}: {
  imports = [
    inputs.inir.homeModules.default
  ];

  programs.inir.enable = true;
}
