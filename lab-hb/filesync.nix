{ config, ... }:
{
  services = {
    syncthing = {
      enable = true;

      # when default 127.0.0.1 is used, syncthing gui shows "Host check error"
      guiAddress = "0.0.0.0:8384";

      settings = {
        devices = {
          "carla" = {
            id = "N66XTE4-DOVHGQQ-5T67FG3-X3N7S3Q-VOBNHUV-AK3PWHL-6G4HMKM-N2LJRAK";
          };
          "nico" = {
            id = "IHAT2KE-ABG7MLC-KV7YVQS-H4UTEWP-XPW4VOG-J3LYYYB-5SJOVOH-ZIPLTQG";
          };
          "telepunkinas" = {
            id = "BLTSTMT-3AJORNM-ZHNWBTA-WTJZQID-TS2Z7ZZ-TKOFPKW-ZCGNZDT-VOC4BAW";
          };
        };
        folders = {
          "cook" = {
            path = "/var/lib/syncthing/cook-cli";
            devices = [ "carla" ];
          };
          "obsidian-notes" = {
            path = "/var/lib/syncthing/obsidian-notes";
            devices = [
              "carla"
              "nico"
            ];
          };
          "tv" = {
            path = "/var/lib/syncthing/tv";
            devices = [
              "nico"
              "telepunkinas"
            ];
          };
        };
      };
    };
  };

  systemd.services.syncthing.unitConfig.RequiresMountsFor = [ ];

  fileSystems = {
    "/var/lib/syncthing/cook-cli" = {
      device = "/var/lib/cook-cli";
      fsType = "fuse.bindfs";
      options = [
        "force-user=${config.services.syncthing.user}"
        "force-group=${config.services.syncthing.group}"
        "perms=755"
        "create-for-user=cook-cli"
        "create-for-group=cook-cli"
        "create-with-perms=755"
        "chmod-ignore"
        "allow_other"
      ];
    };
  };
}
