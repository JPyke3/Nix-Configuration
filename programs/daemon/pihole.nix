{inputs, ...}: let
  serverIP = "100.73.94.58";
in {
  virtualisation.oci-containers.containers.pihole = {
    image = "pihole/pihole:latest";
    ports = [
      "${serverIP}:53:53/tcp"
      "${serverIP}:53:53/udp"
      "3080:80"
    ];
    volumes = [
      "/home/jacobpyke/pihole-config/pihole:/etc/pihole/"
      "/home/jacobpyke/pihole-config/dnsmasq.d:/etc/dnsmasq.d/"
    ];
    environment = {
      ServerIP = serverIP;
      WEB_PORT = "3080";
    };
    extraOptions = [
      "--network=host"
    ];
  };
}
