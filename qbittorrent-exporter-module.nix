{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.qbittorrent-exporter;

  defaultEnvironment = {
    EXPORTER_PORT = toString cfg.port;
  };

  finalEnvironment = defaultEnvironment // cfg.environment;
in {
  options.services.qbittorrent-exporter = {
    enable = mkEnableOption "qbittorrent-exporter";

    package = mkOption {
      type = types.package;
      default = pkgs.callPackage ./qbittorrent-exporter.nix { };
      description = "The qbittorrent-exporter package to use";
    };

    port = mkOption {
      type = types.port;
      default = 8090;
      description = "Port to listen on";
    };

    environment = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Environment variables to set for the service";
    };

    user = mkOption {
      type = types.str;
      default = "qbittorrent-exporter";
      description = "User to run the exporter as";
    };

    group = mkOption {
      type = types.str;
      default = "qbittorrent-exporter";
      description = "Group to run the exporter as";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.qbittorrent-exporter = {
      description = "qbittorrent-exporter";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/qbit-exp";
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";

        # Security hardening
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        NoNewPrivileges = true;
      };

      environment = finalEnvironment;
    };

    users.users.qbittorrent-exporter = {
      isSystemUser = true;
      group = cfg.group;
    };
    users.groups.qbittorrent-exporter = { };
  };
}
