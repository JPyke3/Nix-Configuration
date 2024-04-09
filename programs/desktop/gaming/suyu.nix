{inputs, ...}: {
  home.packages = with inputs.nur; [
    suyu
  ];
}
