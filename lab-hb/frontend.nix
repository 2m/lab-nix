{ config, ... }:
{
  services.caddy = {
    enable = true;
    virtualHosts."https://${config.vars.fqdn}".extraConfig = ''
      header Content-Type text/html
      respond "
        <h3>Welcome to the 2m lab</h3>
        <dl>
          <dt><a href='https://irc.${config.vars.fqdn}'>https://irc.${config.vars.fqdn}</a></dt>
          <dd>The Lounge IRC Web client</dd>
          <dt><a href='https://books.${config.vars.fqdn}'>https://books.${config.vars.fqdn}</a></dt>
          <dd>Calibre Web book library</dd>
          <dt><a href='https://mon.${config.vars.fqdn}'>https://mon.${config.vars.fqdn}</a></dt>
          <dd>Server monitoring</dd>
          <dt><a href='https://cars.${config.vars.fqdn}/'>https://cars.${config.vars.fqdn}/</a></dt>
          <dd>Car maintenance tracking</dd>
          <dt><a href='https://track.${config.vars.fqdn}/'>https://track.${config.vars.fqdn}/</a></dt>
          <dd>Location tracking</dd>
          <dt><a href='https://torrents.${config.vars.fqdn}/'>https://torrents.${config.vars.fqdn}/</a></dt>
          <dd>Torrent Downloads</dd>
          <dt><a href='https://jelly.${config.vars.fqdn}/'>https://jelly.${config.vars.fqdn}/</a></dt>
          <dd>Jellyfin</dd>
          <dt><a href='https://radarr.${config.vars.fqdn}/'>https://radarr.${config.vars.fqdn}/</a></dt>
          <dd>Radarr</dd>
          <dt><a href='https://bazarr.${config.vars.fqdn}/'>https://bazarr.${config.vars.fqdn}/</a></dt>
          <dd>bazarr</dd>
          <dt><a href='https://jackett.${config.vars.fqdn}/'>https://jackett.${config.vars.fqdn}/</a></dt>
          <dd>Jackett</dd>
          <dt><a href='https://nax.${config.vars.fqdn}/'>https://nax.${config.vars.fqdn}/</a></dt>
          <dd>NetAlertX</dd>
        </dl>
      "
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://irc.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.thelounge.port}
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://books.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.calibre-web.listen.port}
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://mon.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.grafana.settings.server.http_port}
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://cars.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.lubelogger.port}
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://track.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.dawarich.webPort}
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://torrents.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.qbittorrent.webuiPort}
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://jelly.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:8096
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://radarr.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.radarr.settings.server.port}
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://jackett.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.jackett.port}
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://bazarr.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.bazarr.listenPort}
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://nax.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.netalertx.port}
      ${config.vars.tlsConfig}
    '';
    virtualHosts."${config.services.netalertx.backendApiUrl}".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.netalertx.graphqlPort}
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
