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
          scrape_interval = "60s";
          static_configs = [
            {
              targets = [ "127.0.0.1:9100" "127.0.0.1:${toString config.services.intel-gpu-exporter.port}" "lab-rpi.2m.lt:9100" ];
              labels.type = "node";
            }
          ];
        }
        {
          job_name = "victoriametrics";
          scrape_interval = "60s";
          static_configs = [ { targets = [ "http://127.0.0.1:8428/metrics" ]; } ];
        }
        {
          job_name = "qbittorrent";
          scrape_interval = "60s";
          static_configs = [ { targets = [ "http://127.0.0.1:${toString config.services.qbittorrent-exporter.port}/metrics" ]; } ];
        }
        {
          job_name = "speedtest_lab_rpi";
          scrape_interval = "5m";
          scrape_timeout = "2m";
          static_configs = [ { targets = [ "http://lab-rpi.2m.lt:7979/probe?module=default&target=https://speedtest.lab-rpi.2m.lt" ]; } ];
        }
      ];
    };
  };
}
