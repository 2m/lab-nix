{ config, lib, ... }:
{
  options = {
    services.oauth2-proxy.port = lib.mkOption {
      type = lib.types.int;
      description = "Port of the oauth2-proxy service";
      default = 9999;
    };

  };

  config = {

    age.secrets.dex.file = ../../secrets/dex.age;
    age.secrets.oauth2_proxy.file = ../../secrets/oauth2_proxy.age;
    age.secrets.oauth2_proxy_cookie_secret.file = ../../secrets/oauth2_proxy_cookie_secret.age;

    services = {
      dex = {
        enable = true;
        settings = {
          issuer = "https://dex.lab.2m.lt";
          storage = {
            type = "sqlite3";
            config.file = "/var/lib/dex/dex.db";
          };
          web.http = "127.0.0.1:5556";
          frontend.dir = "${./dex-web}";
          oauth2.skipApprovalScreen = true;

          staticClients = [
            {
              id = "miniflux";
              name = "Miniflux";
              secretEnv = "OIDC_SECRET_MINIFLUX";
              redirectURIs = [ "https://rss.lab.2m.lt/oauth2/oidc/callback" ];
            }
            {
              id = "oauth2-proxy";
              name = "OAuth2 Proxy";
              secretEnv = "OIDC_SECRET_OAUTH2_PROXY";
              redirectURIs = [ "https://oauth.lab.2m.lt/oauth2/callback" ];
            }
          ];

          # passwords are hashed with
          # echo <password> | htpasswd -BinC 10 <username> | cut -d: -f2
          enablePasswordDB = true;
          staticPasswords = [
            {
              email = "tynas@2m.lt";
              username = "tynas";
              userID = "b8a1f2b0-0000-0000-0000-000000000001";
              hash = "$2y$10$WOojcdaZItfqKo8F2JMRieoQMsE/MXQBbPyhDICO2QYoRVRz6n7sm";
            }
            {
              email = "myda@2m.lt";
              username = "myda";
              userID = "b8a1f2b0-0000-0000-0000-000000000002";
              hash = "$2y$10$UWwPve1hKalloRnCyubCUetjax4gHzAKIayXcD8OiXr87Bz5p4FOm";
            }
            {
              email = "gabrius@2m.lt";
              username = "gabrius";
              userID = "b8a1f2b0-0000-0000-0000-000000000003";
              hash = "$2y$10$A7eWw4Vj5fY.OKQNE17YoeoQrd1clM5igBg99fH6/dxPpdkgPJcta";
            }
          ];
        };
        environmentFile = config.age.secrets.dex.path;
      };

      oauth2-proxy = {
        enable = true;

        provider = "oidc";
        oidcIssuerUrl = "https://dex.lab.2m.lt";

        clientID = "oauth2-proxy";
        keyFile = config.age.secrets.oauth2_proxy.path;

        httpAddress = "http://127.0.0.1:${toString config.services.oauth2-proxy.port}";
        redirectURL = "https://oauth.lab.2m.lt/oauth2/callback";

        scope = "openid email profile";
        email.domains = [ "*" ];
        reverseProxy = true;
        trustedProxyIP = [
          "127.0.0.1/32"
          "::1/128"
        ];

        cookie = {
          name = "_oauth2_proxy_v2";
          domain = "lab.2m.lt";
          secretFile = config.age.secrets.oauth2_proxy_cookie_secret.path;
        };
        extraConfig = {
          skip-provider-button = true;
          approval-prompt = "auto"; # do not show the screen of what oauth2-proxy requests from dex
          code-challenge-method = "S256";

          oidc-email-claim = "name"; # place dex username to X-Auth-Request-Email header
          set-xauthrequest = true; # set X-Auth-Request-Email header after auth
          whitelist-domain = ".lab.2m.lt"; # so url from ?rd is accepted
        };
      };
    };

    systemd.services.dex.serviceConfig.StateDirectory = "dex";
  };
}
