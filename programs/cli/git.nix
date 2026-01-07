{pkgs, ...}: {
  programs.git = {
    enable = true;
    # signing = {
    #   key = "6B3155FBAD28F036";
    #   signByDefault = true;
    # };
    settings = {
      user = {
        email = "github@pyk.ee";
        name = "JPyke3";
      };
      rerere = {
        enabled = true;
        autoUpdate = true;
      };
    };
  };

  programs.diff-so-fancy = {
    enable = true;
    enableGitIntegration = true;
  };
}
