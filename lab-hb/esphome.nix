{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.esphome pkgs.esphome-device-builder ];

  systemd.services.esphome-device-builder = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = [ pkgs.esphome ];  # builder shells out to the CLI to compile
    serviceConfig = {
      ExecStart = "${pkgs.esphome-device-builder}/bin/esphome-device-builder /var/lib/esphome";
      StateDirectory = "esphome";
      DynamicUser = true;
    };
  };

  # allow device remote builds
  networking.firewall.allowedTCPPorts = [ 6055 ];
}
