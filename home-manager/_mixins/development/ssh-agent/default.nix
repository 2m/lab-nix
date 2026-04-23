{
  config,
  lib,
  ...
}:
{
  services = lib.mkIf config.vars.is.workstation {
    ssh-agent.enable = true;
  };
}
