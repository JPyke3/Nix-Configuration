{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    ryujinx
  ];

  sops.secrets."emulation/switch" = {
    owner = "jacobpyke";
    path = "${config.home.homeDirectory}/.config/Ryujinx/system/Prod.keys";
  };
}
