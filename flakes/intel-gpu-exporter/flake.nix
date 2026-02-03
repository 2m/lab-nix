{
  description = "intel-gpu-exporter flake";

  outputs = { self }: {
    nixosModules.default = { config, lib, pkgs, ... }:
    with lib;
    let
      cfg = config.services.intel-gpu-exporter;
    in {
      options.services.intel-gpu-exporter = {
        enable = mkEnableOption "intel-gpu-exporter";

        package = mkOption {
          type = types.package;
          default = pkgs.callPackage ./intel-gpu-exporter-module.nix { };
          description = "The intel-gpu-exporter package to use";
        };

        port = mkOption {
          type = types.port;
          default = 8100;
          description = "Port to listen on";
        };

        user = mkOption {
          type = types.str;
          default = "intel-gpu-exporter";
          description = "User to run the exporter as";
        };

        group = mkOption {
          type = types.str;
          default = "intel-gpu-exporter";
          description = "Group to run the exporter as";
        };

        device = mkOption {
          type = types.str;
          default = "drm:/dev/dri/card0";
          description = "Device to run the exporter against as";
        };
      };

      config = mkIf cfg.enable {
        systemd.services.intel-gpu-exporter = {
          description = "intel-gpu-exporter";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];

          serviceConfig = {
            ExecStart = "${cfg.package}/bin/intel-gpu-exporter -device ${cfg.device} -interval 5s -prom.addr :${toString cfg.port}";
            User = cfg.user;
            Group = cfg.group;
            Restart = "on-failure";

            # Security hardening
            PrivateTmp = true;
            ProtectSystem = "strict";
            ProtectHome = true;

            Environment = [
              "PATH=$PATH:/run/wrappers/bin"
            ];
          };
        };

        users.users.intel-gpu-exporter = {
          isSystemUser = true;
          group = cfg.group;
        };
        users.groups.intel-gpu-exporter = { };

        hardware.intel-gpu-tools.enable = true; # enables security wrappers
      };
    };
  };
}
