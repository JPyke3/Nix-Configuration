{inputs, ...}: let
  serverIP = "0.0.0.0";
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
      INTERFACE = "tailscale0";
    };
    extraOptions = [
      "--network=host"
    ];
  };

  # Configure the host to use Pi-hole as its DNS server
  networking.nameservers = ["127.0.0.1"];
  networking.dhcpcd.extraConfig = "nohook resolv.conf";
}
