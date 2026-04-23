{ config, lib, ... }:

{
  options.vars = {
    fqdn = lib.mkOption {
      type = lib.types.str;
      description = "Full domain name of this machine";
    };

    hostname = lib.mkOption {
      type = lib.types.str;
      description = "Local hostname of this machine";
    };

    username = lib.mkOption {
      type = lib.types.str;
      description = "Main username of this machine";
    };

    kind = lib.mkOption {
      type = lib.types.enum [
        "workstation"
        "server"
      ];
      description = "Kind of this machine";
    };

    # --------------
    #  Derived vars
    # --------------

    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdOC8PgQg6ZZG51pdVRFoihpD9a9D3e4gQKmDB/JVmh carla-31-03-2023"
      ];
      description = "Authorized SSH keys for this machine";
    };

    tlsConfig = lib.mkOption {
      type = lib.types.str;
      default = ''
        tls /var/lib/acme/${config.vars.fqdn}/cert.pem /var/lib/acme/${config.vars.fqdn}/key.pem {
          protocols tls1.3
        }
      '';
      description = "TLS config to be used for Caddy virtual hosts";
    };

    is = {
      server = lib.mkOption {
        type = lib.types.bool;
        default = config.vars.kind == "server";
        description = "Whether this machine is a server";
      };

      workstation = lib.mkOption {
        type = lib.types.bool;
        default = config.vars.kind == "workstation";
        description = "Whether this machine is a workstation";
      };
    };
  };
}
