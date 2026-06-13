{
  config,
  pkgs,
  lib,
  ...
}:

let
  homeDir = config.home.homeDirectory;
  dataDir = "${homeDir}/.local/share/grafana";
  logsDir = "${homeDir}/.local/var/log/grafana";
  pluginsDir = "${dataDir}/plugins";

  duckdbPluginVersion = "0.4.3";
  duckdbPluginName = "motherduck-duckdb-datasource";

  grafanaIni = pkgs.writeText "grafana.ini" ''
    [server]
    http_port = 3000

    [paths]
    data     = ${dataDir}
    logs     = ${logsDir}
    plugins  = ${pluginsDir}

    [plugins]
    allow_loading_unsigned_plugins = ${duckdbPluginName}

    [auth.anonymous]
    enabled = true
    org_role = Admin
  '';
in
{
  home.packages = [ pkgs.grafana ];

  # Create required directories and download the DuckDB plugin on activation
  home.activation.grafanaSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p ${dataDir} ${logsDir} ${pluginsDir}

      PLUGIN_DIR="${pluginsDir}/${duckdbPluginName}"

      if [ ! -d "$PLUGIN_DIR" ]; then
        echo "Downloading Grafana DuckDB plugin..."
        ARCH=$(uname -m)
        case "$ARCH" in
          arm64)  PLATFORM="darwin_arm64" ;;
          x86_64) PLATFORM="darwin_amd64" ;;
          *)      echo "Unsupported arch: $ARCH"; exit 1 ;;
        esac

        TMPFILE=$(mktemp /tmp/grafana-duckdb-XXXXXX.zip)
        ${pkgs.curl}/bin/curl -fsSL \
          "https://github.com/motherduckdb/grafana-duckdb-datasource/releases/download/v${duckdbPluginVersion}/${duckdbPluginName}-${duckdbPluginVersion}.zip" \
          -o "$TMPFILE"

        # Extract into a versioned subdir, since the zip has no top-level folder
        mkdir -p "$PLUGIN_DIR"
        ${pkgs.unzip}/bin/unzip -q "$TMPFILE" -d "$PLUGIN_DIR"
        rm "$TMPFILE"

        # Remove binaries for other platforms to save ~300MB
        find "$PLUGIN_DIR" -name 'gpx_*' ! -name "gpx_duckdb_datasource_$PLATFORM" -delete

        echo "DuckDB plugin installed."
      fi
  '';

  # Launchd agent to run Grafana as a background service
  launchd.agents.grafana = {
    enable = true;
    config = {
      Label = "dev.grafana";
      ProgramArguments = [
        "${pkgs.grafana}/bin/grafana"
        "server"
        "--config=${grafanaIni}"
        "--homepath=${pkgs.grafana}/share/grafana"
        "cfg:default.paths.data=${dataDir}"
        "cfg:default.paths.logs=${logsDir}"
        "cfg:default.paths.plugins=${pluginsDir}"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${logsDir}/grafana.log";
      StandardErrorPath = "${logsDir}/grafana-error.log";
    };
  };
}
