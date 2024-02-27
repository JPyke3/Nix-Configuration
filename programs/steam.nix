{pkgs, ...}: {
  home.packages = with pkgs; [
    steam
    steamcmd
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };
}
