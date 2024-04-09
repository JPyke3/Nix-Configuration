{pkgs, ...}: {
  home.packages = with pkgs.nur.repos.chigyutendies; [
    suyu
  ];
}
