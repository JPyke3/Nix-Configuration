{...}: {
  virtualisation.oci-containers = {
    backend = "podman";
    containers.homeassistant = {
      volumes = ["home-assistant:/config"];
      environment.TZ = "Europe/Berlin";
      image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
      extraOptions = [
        "--network=host"
      ];
    };
  };

  services.mosquitto = {
    enable = true;
      listeners = [
    {
      acl = [ "pattern readwrite #" ];
      omitPasswordAuth = true;
      settings.allow_anonymous = true;
    }
  };

  networking.firewall.allowedTCPPortRanges = [
    {
      from = 100;
      to = 65535;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 100;
      to = 65535;
    }
  ];
}
