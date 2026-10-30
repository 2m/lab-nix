{ lib, config, ... }:
lib.mkIf config.vars.is.workstation {
  programs.pi-coding-agent = {
    enable = true;
  };
}
