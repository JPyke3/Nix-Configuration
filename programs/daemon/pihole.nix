{inputs, ...}: let
  serverIP = "192.168.0.3";
in {
  virtualisation.oci-containers.containers.pihole = {
    image = "pihole/pihole:latest";
    ports = [
      "${serverIP}:53:53/tcp"
      "${serverIP}:53:53/udp"
      "3080:80"
      "30443:443"
    ];
    volumes = [
      "/home/jacobpyke/pihole-config/pihole:/etc/pihole/"
      "/home/jacobpyke/pihole-config/dnsmasq.d:/etc/dnsmasq.d/"
    ];
    environment = {
      ServerIP = serverIP;
    };
    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--dns=127.0.0.1"
      "--dns=1.1.1.1"
    ];
    workdir = "/home/jacobpyke/pihole-config/";
  };
}
