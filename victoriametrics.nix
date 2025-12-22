{
  config,
  ...
}:

{
  # Default port: 8428
  services.victoriametrics = {
    enable = true;

    prometheusConfig = {
      global = {
        #     scrape_intervals = "10s";
      };
      scrape_configs = [
        {
          job_name = "node-exporter";
          # stream_parse = true;
          scrape_interval = "60s";
          static_configs = [
            {
              targets = [ "127.0.0.1:9100" ];
              labels.type = "node";
            }
          ];
        }
        {
          job_name = "victoriametrics";
          # stream_parse = true;
          scrape_interval = "60s";
          static_configs = [ { targets = [ "http://127.0.0.1:8428/metrics" ]; } ];
        }
        {
          job_name = "qbittorrent";
          # stream_parse = true;
          scrape_interval = "60s";
          static_configs = [ { targets = [ "http://127.0.0.1:${toString config.services.qbittorrent-exporter.port}/metrics" ]; } ];
        }
      ];
    };
  };

  services.prometheus.exporters.node.enable = true;
}
