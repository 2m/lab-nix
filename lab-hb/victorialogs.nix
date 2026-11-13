{
  ...
}:
let
  syslogPort = 8514;
in
{
  # Default port: 9428
  services.victorialogs = {
    enable = true;
    extraOptions = [
      "-retentionPeriod=14d"
      "-syslog.listenAddr.udp=:${toString syslogPort}"
    ];
  };

  networking = {
    firewall = {
      allowedUDPPorts = [ syslogPort ]; # allow incoming syslog traffic from mikrotik
    };
  };

  services.journald.upload = {
    enable = true;
    settings.Upload.URL = "http://localhost:9428/insert/journald";
  };
}
