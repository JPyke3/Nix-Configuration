{
  config,
  pkgs,
  ...
}: let
  tdarrPort = 8265;
  tdarrServerPort = 8266;
  tdarrDataDir = "/var/lib/tdarr";
in {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  virtualisation.oci-containers.containers.tdarr = {
    image = "ghcr.io/haveagitgat/tdarr";
    ports = [
      "${toString tdarrPort}:8265"
      "${toString tdarrServerPort}:8266"
    ];
    volumes = [
      "${tdarrDataDir}/server:/app/server"
      "${tdarrDataDir}/configs:/app/configs"
      "${tdarrDataDir}/logs:/app/logs"
      "/mypool/media:/media"
      "/mypool/cache:/temp"
      "/dev/dri:/dev/dri"
    ];
    environment = {
      serverIP = "0.0.0.0";
      serverPort = toString tdarrServerPort;
      webUIPort = toString tdarrPort;
      internalNode = "true";
      inContainer = "true";
      ffmpegVersion = "6";
      nodeName = "MyInternalNode";
      TZ = "Europe/London";
      PUID = "1000";
      PGID = "1000";
      UMASK = "0002";
    };
    extraOptions = [
      "--network=bridge"
      "--device=/dev/dri:/dev/dri"
      "--group-add=keep-groups"
    ];
  };

  # Ensure the necessary directories exist
  systemd.tmpfiles.rules = [
    "d ${tdarrDataDir}/server 0775 tdarr media-server -"
    "d ${tdarrDataDir}/configs 0775 tdarr media-server -"
    "d ${tdarrDataDir}/logs 0775 tdarr media-server -"
    "d /var/cache/tdarr 0775 tdarr media-server -"
  ];

  # Create a system user and group for Tdarr
  users.users.tdarr = {
    isSystemUser = true;
    group = "tdarr";
    extraGroups = ["media-server"];
    uid = 1000;
  };
  users.groups.tdarr.gid = 1000;

  # Ensure the media-server group exists
  users.groups.media-server = {};
}
