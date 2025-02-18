{
  config,
  pkgs,
  inputs,
  ...
}: let
  unstable = import inputs.unstable {
    system = "x86_64-linux";
    config.allowUnfree = true; # Enable if needed
  };
in {
  services.whisparr = {
    enable = true;
    package = unstable.whisparr; # Ensure package comes from unstable
    openFirewall = true;
    group = "media-server";
  };

  systemd.services.whisparr.serviceConfig = {
    UMask = "0002";
  };
}
