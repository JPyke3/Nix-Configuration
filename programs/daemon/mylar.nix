{...}: {
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      mylar3 = {
        image = "lscr.io/linuxserver/mylar3:latest";
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "mylar3Config:/config"
          "/media/Comics:/comics"
          "/media/Downloads:/downloads"
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";
          TZ = "Etc/UTC";
        };
		extraOptions = [ "--network=host" ];
        ports = ["8090:8090"];
      };
    };
  };
}
