{
  description = "mikrotik prometheus exporter";

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
          cfg = config.services.prometheus.exporters.mikrotikViaMktxp;

          mktxpConfig = pkgs.lib.generators.toINI { } (
            cfg.deviceConfig
            // {
              default = {
                enabled = true; # turns metrics collection for this RouterOS device on / off
                module_only = false; # use this entry only as a probe module (skip /metrics collection)
                hostname = "localhost"; # RouterOS IP address
                port = 8728; # RouterOS IP Port

                username = ""; # RouterOS user, needs to have 'read' and 'api' permissions
                password = "";
                credentials_file = ""; # To use an external file in YAML format for both username and password, specify the path here

                # Custom labels to be injected to all device metrics, comma-separated key:value (or key=value) pairs
                # Example: "dc:london, rack=a1, service:prod"
                custom_labels = null;

                use_ssl = false; # enables connection via API-SSL servis
                no_ssl_certificate = false; # enables API_SSL connect without router SSL certificate
                ssl_certificate_verify = false; # turns SSL certificate verification on / off
                ssl_check_hostname = true; # check if the hostname matches the peer cert’s hostname
                ssl_ca_file = ""; # path to the certificate authority file to validate against, leave empty to use system store
                plaintext_login = true; # for legacy RouterOS versions below 6.43 use False

                health = true; # System Health metrics
                installed_packages = false; # Installed packages
                dhcp = true; # DHCP general metrics
                dhcp_lease = true; # DHCP lease metrics

                connections = true; # IP connections metrics
                connection_stats = true; # Open IP connections metrics
                connection_stats_destinations = false; # Set to True to track individual destination IPs/ports (Warning: High Cardinality)

                interface = true; # Interfaces traffic metrics
                wireguard_peers = false; # Wireguard peers metrics
                bridge_vlan = false; # Bridge VLAN metrics

                route = true; # IPv4 Routes metrics
                pool = true; # IPv4 Pool metrics
                firewall = true; # IPv4 Firewall rules traffic metrics
                neighbor = true; # IPv4 Reachable Neighbors
                address_list = null; # Firewall Address List metrics, a comma-separated list of names
                dns = true; # DNS stats

                ipv6_route = false; # IPv6 Routes metrics
                ipv6_pool = false; # IPv6 Pool metrics
                ipv6_firewall = false; # IPv6 Firewall rules traffic metrics
                ipv6_neighbor = false; # IPv6 Reachable Neighbors
                ipv6_address_list = null; # IPv6 Firewall Address List metrics, a comma-separated list of names

                poe = true; # POE metrics
                monitor = false; # Interface monitor metrics
                netwatch = false; # Netwatch metrics
                public_ip = true; # Public IP metrics
                wireless = false; # WLAN general metrics
                wireless_clients = false; # WLAN clients metrics
                capsman = false; # CAPsMAN general metrics
                capsman_clients = false; # CAPsMAN clients metrics
                w60g = false; # W60G metrics

                eoip = false; # EoIP status metrics
                gre = false; # GRE status metrics
                ipip = false; # IPIP status metrics
                lte = false; # LTE signal and status metrics (requires additional 'test' permission policy on RouterOS v6)
                ipsec = false; # IPSec active peer metrics
                switch_port = false; # Switch Port metrics

                kid_control_assigned = false; # Allow Kid Control metrics for connected devices with assigned users
                kid_control_dynamic = false; # Allow Kid Control metrics for all connected devices, including those without assigned user

                user = true; # Active Users metrics
                queue = false; # Queues metrics

                bfd = false; # BFD sessions metrics
                bgp = false; # BGP sessions metrics
                routing_stats = false; # Routing process stats
                certificate = false; # Certificates metrics

                container = false; # Containers metrics

                remote_dhcp_entry = "None"; # An MKTXP entry to provide for remote DHCP info / resolution
                remote_capsman_entry = "None"; # An MKTXP entry to provide for remote capsman info

                # Format to use for interface / resource names, allowed values: 'name', 'comment', or 'combined'
                # 'name': use interface name only (e.g. 'ether1')
                # 'comment': use comment if available, fallback to name if not
                # 'combined': use both (e.g. 'ether1 (Office Switch)')
                interface_name_format = "name";

                check_for_updates = false; # check for available ROS updates
              };
            }
          );

          exporterConfig = pkgs.lib.generators.toINI { } {
            MKTXP = {
              listen = "0.0.0.0:${toString cfg.port}";
              socket_timeout = 5;

              initial_delay_on_failure = 120;
              max_delay_on_failure = 900;
              delay_inc_div = 5;

              bandwidth = false; # Turns metrics bandwidth metrics collection on / off
              bandwidth_test_dns_server = "8.8.8.8"; # The DNS server to be used for the bandwidth test connectivity check
              bandwidth_test_interval = 600; # Interval for collecting bandwidth metrics
              minimal_collect_interval = 5; # Minimal metric collection interval

              verbose_mode = false; # Set it on for troubleshooting

              fetch_routers_in_parallel = false; # Fetch metrics from multiple routers in parallel / sequentially
              max_worker_threads = 5; # Max number of worker threads that can fetch routers (parallel fetch only)
              max_scrape_duration = 30; # Max duration of individual routers' metrics collection (parallel fetch only)
              total_max_scrape_duration = 90; # Max overall duration of all metrics collection (parallel fetch only)
              http_server_threads = 16; # Number of worker threads for the HTTP server

              persistent_router_connection_pool = true; # Use a persistent router connections pool between scrapes
              persistent_dhcp_cache = true; # Persist DHCP cache between metric collections
              compact_default_conf_values = false; # Compact mktxp.conf, so only specific values are kept on the individual routers' level
              prometheus_headers_deduplication = false; # Deduplicate Prometheus HELP / TYPE headers in the metrics output

              probe_connection_pool = false; # Enable probe-only connection reuse keyed by module+target
              probe_connection_pool_ttl = 300; # Probe connection TTL in seconds
              probe_connection_pool_max_size = 128; # Max number of probe connections to keep
            };
          };

          configFileDir = pkgs.runCommand "mktxp_conf" { } ''
            mkdir -p $out
            echo '${mktxpConfig}' > $out/mktxp.conf
            echo '${exporterConfig}' > $out/_mktxp.conf
          '';
        in
        {
          options.services.prometheus.exporters.mikrotikViaMktxp = {
            enable = mkEnableOption "mikrotik";

            package = mkOption {
              type = types.package;
              default = pkgs.mktxp;
              description = "The mktxp package to use";
            };

            port = mkOption {
              type = types.port;
              default = 49090;
              description = "Port to listen on";
            };

            user = mkOption {
              type = types.str;
              default = "mikrotik-exporter";
              description = "User to run the exporter as";
            };

            group = mkOption {
              type = types.str;
              default = "mikrotik-exporter";
              description = "Group to run the exporter as";
            };

            deviceConfig = mkOption {
              type = types.attrs;
              description = "Device configuration to scrape";
              example = literalExpression ''
                router-name = {
                  hostname = "192.168.1.1";
                  credentials_file = ...;
                };
              '';
            };
          };

          config = mkIf cfg.enable {
            systemd.services.mikrotik-exporter = {
              description = "mikrotik exporter";
              wantedBy = [ "multi-user.target" ];
              after = [ "network.target" ];

              serviceConfig = {
                ExecStart = "${lib.getExe pkgs.mktxp} --cfg-dir ${configFileDir} export";
                User = cfg.user;
                Group = cfg.group;
                Restart = "on-failure";

                # Security hardening
                PrivateTmp = true;
                ProtectSystem = "strict";
                ProtectHome = true;
              };

              environment = {
                # otherwise service output is batched in 20minute intervals
                PYTHONUNBUFFERED = "1";
              };
            };

            users.users.mikrotik-exporter = {
              isSystemUser = true;
              group = cfg.group;
            };
            users.groups.mikrotik-exporter = { };
          };
        };
    }
    // inputs.flake-utils.lib.eachDefaultSystem (system: {
      formatter = inputs.nixpkgs.legacyPackages.${system}.nixfmt-tree;
    });
}
