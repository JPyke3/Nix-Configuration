{pkgs, ...}: {
  programs.git = {
    enable = true;
    diff-so-fancy = {
      enable = true;
    };
    userEmail = "github@pyk.ee";
    userName = "JPyke3";
    signing.key = "6B3155FBAD28F036";
    extraConfig = {
      rerere = {
        enabled = true;
        autoUpdate = true;
      };
    };
  };
}
