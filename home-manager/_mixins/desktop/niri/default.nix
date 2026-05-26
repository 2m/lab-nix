{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs = {
    niri = lib.mkIf (config.vars.is.workstation && config.vars.is.linux) {
      enable = true;
      settings = {
        prefer-no-csd = true;
        input.keyboard.xkb = {
          layout = "us";
          variant = "intl";
        };
        layout = {
          gaps = 4;
          focus-ring = {
            enable = true;
            width = 2;
          };
        };
      };
    };
  };
}
