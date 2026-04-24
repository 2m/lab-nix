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

    platform = lib.mkOption {
      type = lib.types.str;
      description = "Architecture string (e.g. \"x86_64-linux\", \"aarch64-darwin\") of this machine";
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
      readOnly = true;
    };

    tlsConfig = lib.mkOption {
      type = lib.types.str;
      default = ''
        tls /var/lib/acme/${config.vars.fqdn}/cert.pem /var/lib/acme/${config.vars.fqdn}/key.pem {
          protocols tls1.3
        }
      '';
      description = "TLS config to be used for Caddy virtual hosts";
      readOnly = true;
    };

    os = lib.mkOption {
      type = lib.types.enum [
        "linux"
        "darwin"
      ];
      default = if lib.hasSuffix "-linux" config.vars.platform then "linux" else "darwin";
      description = "OS of this machine, derived from platform. Never set manually.";
      readOnly = true;
    };

    is = {
      server = lib.mkOption {
        type = lib.types.bool;
        default = config.vars.kind == "server";
        description = "Whether this machine is a server";
        readOnly = true;
      };

      workstation = lib.mkOption {
        type = lib.types.bool;
        default = config.vars.kind == "workstation";
        description = "Whether this machine is a workstation";
        readOnly = true;
      };

      darwin = lib.mkOption {
        type = lib.types.bool;
        default = config.vars.os == "darwin";
        description = "Whether this machine runs macOS (Darwin).";
        readOnly = true;
      };

      linux = lib.mkOption {
        type = lib.types.bool;
        default = config.vars.os == "linux";
        description = "Whether this machine runs Linux.";
        readOnly = true;
      };
    };
  };
}
