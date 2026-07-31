{ config, lib, ... }:
let
  port = config.services.searx.port;
in
{
  options = {
    services.searx.port = lib.mkOption {
      type = lib.types.int;
      description = "Port of the SearcXNG service";
      default = 5588;
    };
  };

  config = {
    age.secrets.searx = {
      file = ../secrets/searx.age;
      owner = "searx";
      group = "searx";
    };

    services = {
      searx = {
        enable = true;
        domain = "search.lab.2m.lt";
        settings = {
          server.port = port;
          server.secret_key = "$SEARX_SECRET_KEY";
        };
        environmentFile = config.age.secrets.searx.path;
      };
    };
  };
}
