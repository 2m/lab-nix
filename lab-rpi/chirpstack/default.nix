{ ... }:
{
  services.chirpstack-network-server = {
    enable = true;
    settings = {
      integration.mqtt = {
        server = "tcp://hassio.kambarys.2m.lt:1883";
        username = "chirpstack";
        password = "chirpstack";
      };
    };
    region.eu868.gateway.backend.mqtt = {
      server = "tcp://hassio.kambarys.2m.lt:1883";
      username = "chirpstack";
      password = "chirpstack";
    };
  };

  services.chirpstack-gateway-bridge = {
    enable = true;
    settings = {
      integration.mqtt = {
        event_topic_template = "eu868/gateway/{{ .GatewayID }}/event/{{ .EventType }}";
        state_topic_template = "eu868/gateway/{{ .GatewayID }}/state/{{ .StateType }}";
        command_topic_template = "eu868/gateway/{{ .GatewayID }}/command/#";

        auth.generic = {
          servers = [ "tcp://hassio.kambarys.2m.lt:1883" ];
          username = "chirpstack";
          password = "chirpstack";
        };
      };
    };
  };

  # required for chirpstack-gateway-bridge
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
