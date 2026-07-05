{ ... }:
{
  services.chirpstack-network-server = {
    enable = true;
    regionFiles = [ ./region_eu868.toml ];
    configFile = ./chirpstack.toml;
  };

  services.chirpstack-gateway-bridge = {
    enable = true;
    configFile = ./gateway-bridge.toml;
  };

  # required for chirpstack-gateway-bridge
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };

  networking = {
    firewall = {
      allowedUDPPorts = [ 1700 ];
    };
  };

  # required for chirpstack-network-server
  services.redis = {
    servers."" = {
      enable = true;
      port = 6379;
    };
  };
}
