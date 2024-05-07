{
  pkgs,
  inputs,
  ...
}: let
  nur = import inputs.nur {
    nurpkgs = pkgs;
    pkgs = pkgs;
  };
in {
  environment.systemPackages = with pkgs; [
    nur.repos.jpyke3.kanata-bin
  ];

  environment.etc."keyboard.kbd" = {
    enable = true;
    source = ./keyboard.kbd;
  };

  launchd.user.agents.kanata = {
    command = "sudo ${nur.repos.jpyke3.kanata-bin}/bin/kanata --cfg /etc/keyboard.kbd";
    serviceConfig = {
      UserName = "jacobpyke";
      RunAtLoad = true;
      KeepAlive = {
        SuccessfulExit = false;
        Crashed = true;
      };
      StandardErrorPath = "/var/log/kanata.err.log";
      StandardOutPath = "/var/log/kanata.out.log";
      ProcessType = "Interactive";
      Nice = -30;
    };
  };

  security.sudo.extraConfig = ''
    %admin ALL=(root) NOPASSWD: ${nur.repos.jpyke3.kanata-bin}/bin/kanata --cfg /etc/keyboard.kbd
  '';
}
