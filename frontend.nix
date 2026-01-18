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
          <dt><a href='https://irc.lab.2m.lt'>https://irc.lab.2m.lt</a></dt>
          <dd>The Lounge IRC Web client</dd>
          <dt><a href='https://books.lab.2m.lt'>https://books.lab.2m.lt</a></dt>
          <dd>Calibre Web book library</dd>
          <dt><a href='https://mon.lab.2m.lt'>https://mon.lab.2m.lt</a></dt>
          <dd>Server monitoring</dd>
          <dt><a href='https://cars.lab.2m.lt/'>https://cars.lab.2m.lt/</a></dt>
          <dd>Car maintenance tracking</dd>
          <dt><a href='https://track.lab.2m.lt/'>https://track.lab.2m.lt/</a></dt>
          <dd>Location tracking</dd>
          <dt><a href='https://torrents.lab.2m.lt/'>https://torrents.lab.2m.lt/</a></dt>
          <dd>Torrent Downloads</dd>
          <dt><a href='https://jelly.lab.2m.lt/'>https://jelly.lab.2m.lt/</a></dt>
          <dd>Jellyfin</dd>
          <dt><a href='https://radarr.lab.2m.lt/'>https://radarr.lab.2m.lt/</a></dt>
          <dd>Radarr</dd>
          <dt><a href='https://bazarr.lab.2m.lt/'>https://bazarr.lab.2m.lt/</a></dt>
          <dd>bazarr</dd>
          <dt><a href='https://jackett.lab.2m.lt/'>https://jackett.lab.2m.lt/</a></dt>
          <dd>Jackett</dd>
          <dt><a href='https://nax.lab.2m.lt/'>https://nax.lab.2m.lt/</a></dt>
          <dd>NetAlertX</dd>
        </dl>
      "
      ${tlsconfig}
    '';
    virtualHosts."https://irc.lab.2m.lt".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.thelounge.port}
      ${tlsconfig}
    '';
    virtualHosts."https://books.lab.2m.lt".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.calibre-web.listen.port}
      ${tlsconfig}
    '';
    virtualHosts."https://mon.lab.2m.lt".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.grafana.settings.server.http_port}
      ${tlsconfig}
    '';
    virtualHosts."https://cars.lab.2m.lt".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.lubelogger.port}
      ${tlsconfig}
    '';
    virtualHosts."https://track.lab.2m.lt".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.dawarich.webPort}
      ${tlsconfig}
    '';
    virtualHosts."https://torrents.lab.2m.lt".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.qbittorrent.webuiPort}
      ${tlsconfig}
    '';
    virtualHosts."https://jelly.lab.2m.lt".extraConfig = ''
      reverse_proxy http://localhost:8096
      ${tlsconfig}
    '';
    virtualHosts."https://radarr.lab.2m.lt".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.radarr.settings.server.port}
      ${tlsconfig}
    '';
    virtualHosts."https://jackett.lab.2m.lt".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.jackett.port}
      ${tlsconfig}
    '';
    virtualHosts."https://bazarr.lab.2m.lt".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.bazarr.listenPort}
      ${tlsconfig}
    '';
    virtualHosts."https://nax.lab.2m.lt".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.netalertx.port}
      ${tlsconfig}
    '';
    virtualHosts."${config.services.netalertx.backendApiUrl}".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.netalertx.graphqlPort}
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
        "*.lab.2m.lt"
      ];
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
      environmentFile = config.age.secrets.cloudflare_token.path;
    };
  };
}
