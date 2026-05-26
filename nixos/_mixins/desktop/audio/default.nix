{
  pkgs,
  config,
  lib,
  ...
}:
{
  security.rtkit = lib.mkIf (config.vars.is.workstation && config.vars.is.linux) {
    enable = true;
  };

  services.pipewire = lib.mkIf (config.vars.is.workstation && config.vars.is.linux) {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
}
