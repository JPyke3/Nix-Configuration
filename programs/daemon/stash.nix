{...}: {
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      stash = {
        image = "stashapp/stash:latest";
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/adult:/data"
          "stashConfig:/root/.stash"
          "stashMetadata:/metadata"
          "stashCache:/cache"
          "stashBlobs:/blobs"
          "stashGenerated:/generated"
        ];
        environment = {
          STASH_STASH = "/data/";
          STASH_GENERATED = "/generated/";
          STASH_METADATA = "/metadata/";
          STASH_CACHE = "/cache/";
          STASH_PORT = "9999";
        };
        ports = ["9999:9999"];
      };

      stash-vr = {
        image = "ofl0w/stash-vr:latest";
        environment = {
          STASH_GRAPHQL_URL = "http://127.0.0.1:9999/graphql";
        };
        ports = ["9666:9666"];
      };
    };
  };
}
