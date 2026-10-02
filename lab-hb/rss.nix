{ config, lib, ... }:
{
  options = {
    services.rss-bridge.envConf = lib.mkOption {
      type = lib.types.str;
      description = "Additional env variable config to pass to caddy";
    };
  };

  config = {
    age.secrets.miniflux = {
      file = ../secrets/miniflux.age;
      owner = "miniflux";
      group = "miniflux";
    };

    services = {
      miniflux = {
        enable = true;

        # configures admin credentials and oauth2 client secret
        adminCredentialsFile = config.age.secrets.miniflux.path;

        config = {
          LISTEN_ADDR = "localhost:8280";

          OAUTH2_PROVIDER = "oidc";
          OAUTH2_CLIENT_ID = "miniflux";
          OAUTH2_REDIRECT_URL = "https://rss.lab.2m.lt/oauth2/oidc/callback";
          OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://dex.lab.2m.lt";
          OAUTH2_USER_CREATION = 1;

          METRICS_COLLECTOR = 1;

          # allow miniflux to reach rss-bridge
          FETCHER_ALLOW_PRIVATE_NETWORKS = 1;
        };
      };

      rss-bridge = {
        enable = true;
        webserver = "caddy"; # use "caddy" user and group
        virtualHost = null; # this disables auto configuration of caddy
        envConf = ''
          env RSSBRIDGE_FILECACHE_PATH "${config.services.rss-bridge.config.FileCache.path}"
          env RSSBRIDGE_SYSTEM_ENABLED_BRIDGES "*"
        '';
      };
    };
  };
}
