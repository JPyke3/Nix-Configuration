{config, ...}: let
  domain = "pyk.ee";
in {
  sops.secrets."acme/route53" = {};

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "jacob@pyk.ee";
      dnsProvider = "route53";
      dnsPropagationCheck = true;
      dnsResolver = "1.1.1.1:53";
    };
    certs = {
      "${domain}" = {
        extraDomainNames = ["*.${domain}"];
        dnsProvider = "route53";
        credentialsFile = config.sops.secrets."acme/route53".path;
      };
    };
  };
}
