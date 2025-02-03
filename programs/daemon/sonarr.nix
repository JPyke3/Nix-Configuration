{...}: {
  services.sonarr = {
    enable = true;
    openFirewall = true;
    group = "media-server";
    package = pkgs.sonarr.overrideAttrs (lib.const {doCheck = false;});
  };

  systemd.services.sonarr.serviceConfig = {
    UMask = "0002";
  };

  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
  ];
}
