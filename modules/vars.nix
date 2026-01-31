{ config, lib, ... }:

{
  options.vars = {
    fqdn = lib.mkOption {
      type = lib.types.str;
      description = "Full domain name of this server";
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

    hostname = lib.mkOption {
      type = lib.types.str;
      description = "Local hostname of this server";
    };
  };

  # You can also add config that uses these options
  # config = lib.mkIf config.myConfig.enableCustomService {
  #   # Your configuration here
  # };
}
