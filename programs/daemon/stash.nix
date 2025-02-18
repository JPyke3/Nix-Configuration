{...}: {
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      stash = {
        image = "stashapp/stash:latest";
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/adult:/data"
          "/var/lib/stash/config:/root/.stash"
          "/var/lib/stash/metadata:/metadata"
          "/var/lib/stash/cache:/cache"
          "/var/lib/stash/blobs:/blobs"
          "/var/lib/stash/generated:/generated"
        ];
        environment = {
          STASH_STASH = "/data/";
          STASH_GENERATED = "/generated/";
          STASH_METADATA = "/metadata/";
          STASH_CACHE = "/cache/";
          STASH_PORT = "9999";
        };
        ports = ["9999:9999"];
        extraOptions = [
          "--restart=unless-stopped"
        ];
      };
    };
  };
}
