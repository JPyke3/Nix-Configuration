{pkgs, ...}: {
  services.unifi = {
    enable = true;
    openFirewall = true;
    package = pkgs.unifi;
  };
}
