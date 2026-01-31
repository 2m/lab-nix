{ config, ... }:
{
  services.caddy = {
    enable = true;
    virtualHosts."https://${config.vars.fqdn}".extraConfig = ''
      header Content-Type text/html
      respond "
        <h3>Welcome to the 2m rpi lab</h3>
      "
      ${config.vars.tlsConfig}
    '';
  };

  age.secrets.cloudflare_token.file = ../secrets/cloudflare_token.age;

  security.acme = {
    acceptTerms = true;
    defaults.email = "self@2m.lt";

    certs."${config.vars.fqdn}" = {
      group = config.services.caddy.group;

      domain = "${config.vars.fqdn}";
      extraDomainNames = [
        "*.${config.vars.fqdn}"
      ];
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      environmentFile = config.age.secrets.cloudflare_token.path;
    };
  };
}
