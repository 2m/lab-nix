{
  description = "betula service";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { ... }@inputs:
    {
      nixosModules.default =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        with lib;
        let
          cfg = config.services.betula;
        in
        {
          options.services.betula = {
            enable = mkEnableOption "betula";

            package = mkOption {
              type = types.package;
              default = pkgs.betula;
              description = "The betula package to use";
            };

            port = mkOption {
              type = types.port;
              default = 1738;
              description = "Port to listen on";
            };

            user = mkOption {
              type = types.str;
              default = "betula";
              description = "User to run the service as";
            };

            group = mkOption {
              type = types.str;
              default = "betula";
              description = "Group to run the service as";
            };

            dataDir = mkOption {
              type = types.str;
              default = "/var/lib/betula/";
              description = "Path to the directory where betula will persist its state";
            };

          };

          config = mkIf cfg.enable {
            systemd.services.betula = {
              description = "betula";
              wantedBy = [ "multi-user.target" ];
              after = [ "network.target" ];

              serviceConfig = {
                ExecStart = "${pkgs.betula}/bin/betula -port ${toString cfg.port} ${cfg.dataDir}/sqlite.db";
                User = cfg.user;
                Group = cfg.group;
                Restart = "on-failure";

                # Security hardening
                PrivateTmp = true;
                ProtectSystem = "strict";
                ProtectHome = true;
              };
            };

            systemd.tmpfiles.rules = [ "d ${cfg.dataDir} 0755 ${cfg.user} ${cfg.group} - -" ];

            users.users."${cfg.user}" = {
              isSystemUser = true;
              group = cfg.group;
            };
            users.groups."${cfg.group}" = { };
          };
        };
    }
    // inputs.flake-utils.lib.eachDefaultSystem (system: {
      formatter = inputs.nixpkgs.legacyPackages.${system}.nixfmt-tree;
    });
}
