{ config, ... }:
{
  age.secrets.oidc_secret_miniflux_dex.file = ../../secrets/oidc_secret_miniflux_dex.age;

  services.dex = {
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
      ];
    };
    environmentFile = config.age.secrets.oidc_secret_miniflux_dex.path;
  };

  systemd.services.dex.serviceConfig.StateDirectory = "dex";
}
