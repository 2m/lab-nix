{
  config,
  lib,
  pkgs,
  ...
}:
let
  port = config.services.karakeep.port;
in
{
  options = {
    services.karakeep.port = lib.mkOption {
      type = lib.types.int;
      description = "Port of the karakeep service";
      default = 3003;
    };
  };

  config = {
    age.secrets.karakeep = {
      file = ../secrets/karakeep.age;
      owner = "karakeep";
      group = "karakeep";
    };

    services = {
      karakeep = {
        enable = true;
        extraEnvironment = {
          PORT = toString port;
          CRAWLER_FULL_PAGE_SCREENSHOT = "true";
          CRAWLER_FULL_PAGE_ARCHIVE = "true";
        };
        environmentFile = config.age.secrets.karakeep.path;
      };
    };
  };
}
