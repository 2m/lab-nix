{ pkgs, ... }:
let
  soundIn = "hw:CODEC";
  soundOut = "plughw:HPA4";
in
{
  hardware.alsa.enable = true;

  systemd.services.alink = {
    description = "Audio Link between two USB devices";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.alsa-utils}/bin/alsaloop -C ${soundIn} -P ${soundOut} -r 48000 -c 2 -f S16_LE -l 4800";
      Restart = "on-failure";
    };
  };

}
