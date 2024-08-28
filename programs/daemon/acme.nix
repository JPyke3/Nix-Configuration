{config, ...}: let
  domain = "pyk.ee";
in {
  sops.secrets."acme/route53" = {};

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "jacob@pyk.ee";
      dnsPropagationCheck = true;
      dnsResolver = "1.1.1.1:53";
    };
    certs = {
      "${domain}" = {
        extraDomainNames = ["*.${domain}"];
        dnsProvider = "route53";
        credentialsFile = config.sops.secrets."acme/route53".path;
        group = "nginx";
      };
    };
  };
}
