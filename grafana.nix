{
  pkgs,
  ...
}:

{
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
        enable_gzip = true;
      };
      analytics.reporting_enabled = false;
    };

    provision = {
      dashboards.settings.providers = [
        {
          name = "Overview";
          options.path = "/etc/grafana-dashboards";
        }
      ];

      datasources.settings = {
        apiVersion = 1;
        datasources = [
          {
            name = "VictoriaMetrics";
            type = "victoriametrics-metrics-datasource";
            access = "proxy";
            url = "http://127.0.0.1:8428";
            isDefault = true;
          }

          {
            name = "VictoriaLogs";
            type = "victoriametrics-logs-datasource";
            access = "proxy";
            url = "http://127.0.0.1:9428";
            isDefault = false;
          }
        ];
      };
    };

    declarativePlugins = with pkgs.grafanaPlugins; [
      victoriametrics-metrics-datasource
      victoriametrics-logs-datasource
    ];
  };
}
