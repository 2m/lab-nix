{ config, lib, ... }:
let
  dataDir = "/var/lib/cook-cli";
in
{
  services = {
    cook-cli.enable = true;


    samba = {
      settings = {
        "cook" = {
          "path" = dataDir;
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0775"; # allow writing by anyone in the group
          "directory mask" = "0775";
          "force user" = "cook-cli";
          "force group" = "cook-cli";
        };
      };
    };
  };

  systemd.services.cook-cli.serviceConfig.ExecStart = lib.mkForce ''
    ${lib.getExe config.services.cook-cli.package} server --host --port ${toString config.services.cook-cli.port} --cors-origin https://cook.lab.2m.lt ${config.services.cook-cli.basePath}
  '';
}
