{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    ryujinx
  ];

  sops.secrets."emulation/switch" = {
  };
}
