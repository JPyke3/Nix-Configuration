{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    altserver-linux
  ];
}
