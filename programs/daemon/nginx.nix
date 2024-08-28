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
        # forceSSL = true;
        # useACMEHost = "${domain}";
        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
        };
      };
    };
  };
}
