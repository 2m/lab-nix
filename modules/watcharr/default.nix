{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.watcharr;
in
{
  options.services.watcharr = {
    enable = lib.mkEnableOption "Self-hostable watched list (movies, TV, anime, games)";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ../../pkgs/watcharr { };
      description = "watcharr package to run.";
    };

    uiPort = lib.mkOption {
      type = lib.types.int;
      default = 3080; # this is hardcoded in watcharr
      description = "port that watcharr runs on";
    };

    serverPort = lib.mkOption {
      type = lib.types.int;
      default = 3000; # this is hardcoded in watcharr
      description = "port that watcharr runs on";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/watcharr";
      description = "Mutable watcharr state directory.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "watcharr";
      description = "User running watcharr.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "watcharr";
      description = "Group running watcharr.";
    };
  };

  config = {
    users.groups.${cfg.group} = { };
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.watcharr = {
      description = "Watcharr server";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        WATCHARR_DATA = toString cfg.dataDir;
      };
      path = [ pkgs.nodejs_24 ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;

        # Run inside the store path so relative "./ui" resolves
        WorkingDirectory = cfg.package;

        # Prefer $out/bin/watcharr; fall back to $out/bin/server if needed
        ExecStart = "${cfg.package}/bin/Watcharr";

        Restart = "on-failure";
        RestartSec = "2s";

        # Hardening (unchanged)
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        # Allow writes only to the data dir
        ReadWritePaths = [ cfg.dataDir ];
      };
    };
  };
}
