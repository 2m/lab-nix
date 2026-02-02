{ config, pkgs, ... }:
let
  speedtest-cgi = pkgs.writers.writeBashBin "speedtest-cgi" ''
    printf "Content-type: application/json\n\n"

    ${pkgs.speedtest-cli}/bin/speedtest --json
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

  environment.etc = {
    "prometheus_json_exporter_config.yaml" = {
      text = ''
        ---
        modules:
          default:
            metrics:
            - name: speedtest_down
              path: '{ .download }'
              help: Download bandwidth in bytes per second during speedtest
              labels:
                server_host: '{.server.host}'
                server_name: '{.server.sponsor}'
                server_country: '{.server.cc}'
                server_id: '{.server.id}'
                server_distance: '{.server.d}'
            - name: speedtest_up
              path: '{ .upload }'
              help: Upload bandwidth in bytes per second during speedtest
              labels:
                server_host: '{.server.host}'
                server_name: '{.server.sponsor}'
                server_country: '{.server.cc}'
                server_id: '{.server.id}'
                server_distance: '{.server.d}'
            - name: speedtest_ping
              path: '{ .ping }'
              help: Ping in milliseconds during speedtest
              labels:
                server_host: '{.server.host}'
                server_name: '{.server.sponsor}'
                server_country: '{.server.cc}'
                server_id: '{.server.id}'
                server_distance: '{.server.d}'
      '';
    };
  };

  services.prometheus.exporters.json = {
    enable = true;
    configFile = "/etc/prometheus_json_exporter_config.yaml";
  };
}
