{
  pkgs,
  lib,
  ...
}: {
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

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      sonarr_yt-dlp = {
        image = "jpyke3/sonarr_yt-dlp:latest";
        volumes = [
          "sonarrYtdlpConfig:/config"
          "/media/TV Shows:/sonarr_root"
          "sonarrYtdlpLogs:/logs"
        ];
        extraOptions = [
          "--network=host"
        ];
      };
    };
  };
}
