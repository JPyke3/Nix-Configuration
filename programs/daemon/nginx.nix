{
  config,
  pkgs,
  ...
}: let
  domain = "pyk.ee";
in {
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "nextcloud.${domain}" = {
        listen = [
          {
            addr = "100.73.94.58";
            port = "80";
          }
        ];
        forceSSL = true;
        useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
        };
      };
    };
  };
}
