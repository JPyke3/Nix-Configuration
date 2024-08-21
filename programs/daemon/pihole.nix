{...}: {
  # required for stable restarts of the Pi-hole container (try to remove it to see the warning from the pihole-flake)
  boot.cleanTmpDir = true;

  # the Pi-hole service configuration
  services.pihole = {
    enable = true;
    hostConfig = {
      # define the service user for running the rootless Pi-hole container
      user = "pihole";
      enableLingeringForUser = true;

      # we want to persist change to the Pi-hole configuration & logs across service restarts
      # check the option descriptions for more information
      persistVolumes = true;

      # expose DNS & the web interface on unpriviledged ports on all IP addresses of the host
      # check the option descriptions for more information
      dnsPort = 5335;
      webProt = 8080;
    };
    piholeConfig.ftl = {
      # assuming that the host has this (fixed) IP and should resolve "pi.hole" to this address
      # check the option description & the FTLDNS documentation for more information
      LOCAL_IPV4 = "192.168.0.3";
    };
    piholeCOnfig.web = {
      virtualHost = "pi.hole";
      password = "password";
    };
  };

  # we need to open the ports in the firewall to make the service accessible beyond `localhost`
  # assuming that Pi-hole is exposed on the host interface `eth0`
  networking.firewall.interfaces.eth0 = {
    allowedTCPPorts = [5335 8080];
    allowedUDPPorts = [5335];
  };
}
