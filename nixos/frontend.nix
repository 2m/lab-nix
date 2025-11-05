{ config, ... }:
let
  tlsconfig = ''
    tls /var/lib/acme/lab.2m.lt/cert.pem /var/lib/acme/lab.2m.lt/key.pem {
      protocols tls1.3
    }
  '';
in
{
  services.caddy = {
    enable = true;
    virtualHosts."https://lab.2m.lt".extraConfig = ''
      header Content-Type text/html
      respond "
        <h3>Welcome to the 2m lab</h3>
        <dl>
          <dt><a href='https://irc.2m.lt'>https://irc.2m.lt</a></dt>
          <dd>The Lounge IRC Web client</dd>
          <dt><a href='https://books.2m.lt'>https://books.2m.lt</a></dt>
          <dd>Calibre Web book library</dd>
          <dt><a href='https://mon.2m.lt'>https://mon.2m.lt</a></dt>
          <dd>Server monitoring</dd>
        </dl>
      "
      ${tlsconfig}
    '';
    virtualHosts."https://irc.2m.lt".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.thelounge.port}
      ${tlsconfig}
    '';
    virtualHosts."https://books.2m.lt".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.calibre-web.listen.port}
      ${tlsconfig}
    '';
    virtualHosts."https://mon.2m.lt".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.grafana.settings.server.http_port}
      ${tlsconfig}
    '';
  };

  age.secrets.cloudflare_token.file = ./secrets/cloudflare_token.age;

  security.acme = {
    acceptTerms = true;
    defaults.email = "self@2m.lt";

    certs."lab.2m.lt" = {
      group = config.services.caddy.group;

      domain = "lab.2m.lt";
      extraDomainNames = [
        "irc.2m.lt"
        "books.2m.lt"
        "mon.2m.lt"
      ];
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      environmentFile = config.age.secrets.cloudflare_token.path;
    };
  };
}
