{pkgs, ...}: {
  programs.git = {
    enable = true;
    diff-so-fancy = {
      enable = true;
    };
    userEmail = "github@pyk.ee";
    userName = "JPyke3";
  };
}
