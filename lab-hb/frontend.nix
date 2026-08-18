{ config, ... }:
{
  services.caddy = {
    enable = true;
    virtualHosts."https://${config.vars.fqdn}".extraConfig = ''
      header Content-Type text/html
      respond "
        <style>
        dd {
          margin-bottom: 10px;
        }
        </style>
        <h3>Welcome to the 2m lab</h3>
        <dl>
          <dt><a href='https://irc.${config.vars.fqdn}'>https://irc.${config.vars.fqdn}</a></dt>
          <dd>The Lounge IRC Web client</dd>
          <dt><a href='https://books.${config.vars.fqdn}'>https://books.${config.vars.fqdn}</a> <a href='https://books-oauth.${config.vars.fqdn}'>https://books-oauth.${config.vars.fqdn}</a></dt>
          <dd>Books library - Calibre</dd>
          <dt><a href='https://mon.${config.vars.fqdn}'>https://mon.${config.vars.fqdn}</a></dt>
          <dd>Server monitoring</dd>
          <dt><a href='https://cars.${config.vars.fqdn}/'>https://cars.${config.vars.fqdn}/</a></dt>
          <dd>Car maintenance tracking</dd>
          <dt><a href='https://track.${config.vars.fqdn}/'>https://track.${config.vars.fqdn}/</a></dt>
          <dd>Location tracking</dd>
          <dt><a href='https://torrents.${config.vars.fqdn}/'>https://torrents.${config.vars.fqdn}/</a></dt>
          <dd>Torrents</dd>
          <dt><a href='https://jelly.${config.vars.fqdn}/'>https://jelly.${config.vars.fqdn}/</a></dt>
          <dd>Jellyfin</dd>
          <dt><a href='https://radarr.${config.vars.fqdn}/'>https://radarr.${config.vars.fqdn}/</a></dt>
          <dd>Movies</dd>
          <dt><a href='https://bazarr.${config.vars.fqdn}/'>https://bazarr.${config.vars.fqdn}/</a></dt>
          <dd>Subtitles</dd>
          <dt><a href='https://lidarr.${config.vars.fqdn}/'>https://lidarr.${config.vars.fqdn}/</a></dt>
          <dd>Music</dd>
          <dt><a href='https://jackett.${config.vars.fqdn}/'>https://jackett.${config.vars.fqdn}/</a></dt>
          <dd>Trackers</dd>
          <dt><a href='https://cook.${config.vars.fqdn}/'>https://cook.${config.vars.fqdn}/</a></dt>
          <dd>Recipes</dd>
          <dt><a href='https://rss.${config.vars.fqdn}/'>https://rss.${config.vars.fqdn}/</a></dt>
          <dd>RSS feeds</dd>
          <dt><a href='https://archive.${config.vars.fqdn}/'>https://archive.${config.vars.fqdn}/</a></dt>
          <dd>Web archiver</dd>
          <dt><a href='https://dex.${config.vars.fqdn}/'>https://dex.${config.vars.fqdn}/</a></dt>
          <dd>OpenID Connect identity</dd>
          <dt><a href='https://oauth.${config.vars.fqdn}/'>https://oauth.${config.vars.fqdn}/</a></dt>
          <dd>
            oauth2-proxy
            <a href='https://oauth.${config.vars.fqdn}/oauth2/sign_in'>Login</a>
            <a href='https://oauth.${config.vars.fqdn}/oauth2/auth'>Headers</a>
            <a href='https://oauth.${config.vars.fqdn}/oauth2/sign_out'>Logout</a>
          </dd>
          <dt><a href='https://st.${config.vars.fqdn}/'>https://st.${config.vars.fqdn}/</a></dt>
          <dd>Syncthing</dd>
          <dt><a href='https://search.${config.vars.fqdn}/'>https://search.${config.vars.fqdn}/</a></dt>
          <dd>SearXNG</dd>
          <dt><a href='https://watchlist.${config.vars.fqdn}/'>https://watchlist.${config.vars.fqdn}/</a></dt>
          <dd>TV and Movie watchlist - Watcharr</dd>
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
    virtualHosts."https://lidarr.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.lidarr.settings.server.port}
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://cook.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.cook-cli.port}
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://rss.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:8280
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://archive.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.karakeep.port}
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://dex.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:5556
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://oauth.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.oauth2-proxy.port}
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://books-oauth.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy https://oauth.${config.vars.fqdn} {
        method GET
        rewrite /oauth2/auth
        header_up X-Forwarded-Method {method}
        header_up X-Forwarded-Uri {uri}

        @authenticated status 2xx
        handle_response @authenticated {
          request_header X-Auth-Request-Email {rp.header.X-Auth-Request-Email}
        }

        @unauthorized status 401
        handle_response @unauthorized {
          redir https://oauth.${config.vars.fqdn}/oauth2/start?rd={scheme}://{host}{uri}
        }
      }

      reverse_proxy https://books.${config.vars.fqdn} {
        header_up Host books.${config.vars.fqdn}
        header_up X-User {header.X-Auth-Request-Email}
      }
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://st.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:8384
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://search.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.searx.port}
      ${config.vars.tlsConfig}
    '';
    virtualHosts."https://watchlist.${config.vars.fqdn}".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.watcharr.uiPort}
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
