{ config, pkgs, ... }:
let
  speedtest-cgi = pkgs.writers.writeBashBin "speedtest-cgi" ''
    printf "Content-type: application/json\n\n"

    ${pkgs.speedtest-cli}/bin/speedtest --json --server $QUERY_STRING
  '';
in
{
  environment.systemPackages = with pkgs; [
    speedtest-cli
  ];

  services.caddy = {
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/aksdb/caddy-cgi/v2@v2.2.7" ];
      hash = "sha256-xj0Zs6fe2Efh6I28l89n1IqWVa5kR+jj+Xq/cIFFUuQ=";
    };
    virtualHosts."https://speedtest.${config.vars.fqdn}".extraConfig = ''
      route {
        cgi * ${speedtest-cgi}/bin/speedtest-cgi
      }
      ${config.vars.tlsConfig}
    '';
  };
}
