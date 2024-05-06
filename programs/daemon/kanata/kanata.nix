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

  launchd.daemons.kanata = {
    command = "exec ${nur.repos.jpyke3.kanata-bin}/bin/kanata --cfg /etc/keyboard.kbd";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
    };
  };
}
