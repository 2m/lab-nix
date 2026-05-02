{
  config,
  ...
}:

{
  age.secrets.router_mktxp = {
    file = ../secrets/router_mktxp.age;
    owner = config.services.prometheus.exporters.mikrotikViaMktxp.user;
    group = config.services.prometheus.exporters.mikrotikViaMktxp.group;
  };
  age.secrets.wifi_mktxp = {
    file = ../secrets/wifi_mktxp.age;
    owner = config.services.prometheus.exporters.mikrotikViaMktxp.user;
    group = config.services.prometheus.exporters.mikrotikViaMktxp.group;
  };
  age.secrets.wifi_rafters_mktxp = {
    file = ../secrets/wifi_rafters_mktxp.age;
    owner = config.services.prometheus.exporters.mikrotikViaMktxp.user;
    group = config.services.prometheus.exporters.mikrotikViaMktxp.group;
  };

  services.prometheus.exporters.mikrotikViaMktxp = {
    enable = true;
    deviceConfig = {
      "router" = {
        hostname = "192.168.88.1";
        credentials_file = config.age.secrets.router_mktxp.path;

        queue = true;
        poe = false;
      };
      "wifi" = {
        hostname = "192.168.88.243";
        credentials_file = config.age.secrets.wifi_mktxp.path;
        remote_dhcp_entry = "router";

        wireless = true;
        wireless_clients = true;
      };
      "wifi-rafters" = {
        hostname = "192.168.88.174";
        credentials_file = config.age.secrets.wifi_rafters_mktxp.path;
        remote_dhcp_entry = "router";

        wireless = true;
        wireless_clients = true;
        poe = false;
      };
    };
  };
}
