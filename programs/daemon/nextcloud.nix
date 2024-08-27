{config, ...}: {
  services.nextcloud = {
    enable = true;
    home = /mypool/documents/nextcloud;
    hostName = "jacob-china.tail264a8.ts.net";
   };

	nixpkgs.config.permittedInsecurePackages = [
┃                 "nextcloud-27.1.11"                                      
┃               ];

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    sslCertificate = /mypool/documents/Tailscale-Certs/jacob-china.tail264a8.ts.net.crt;
    sslCertificateKey = /mypool/documents/Tailscale-Certs/jacob-china.tail264a8.ts.net.key;
  };
}
