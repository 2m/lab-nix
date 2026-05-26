{
  pkgs,
  config,
  lib,
  ...
}:
{
  hardware.graphics = lib.mkIf (config.vars.is.workstation && config.vars.is.linux) {
    enable = true;
  };

  xdg.portal = lib.mkIf (config.vars.is.workstation && config.vars.is.linux) {
    enable = true;
    xdgOpenUsePortal = true;
    config.common.default = "*";
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

}
