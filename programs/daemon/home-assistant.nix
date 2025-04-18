{...}: {
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      homeassistant = {
        volumes = ["home-assistant:/config"];
        environment.TZ = "Europe/Berlin";
        image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
        extraOptions = [
          "--network=host"
          "--device=/dev/serial/by-id/usb-Itead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_V2_24fdb0c68739ef1181b35ef454516304-if00-port0:/dev/ttyUSB0"
        ];
      };
    };
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        acl = ["pattern readwrite #"];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
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
