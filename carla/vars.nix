{ ... }:
{
  imports = [
    ../modules/vars.nix
  ];

  vars.fqdn = "carla.2m.lt";
  vars.hostname = "carla";
  vars.username = "martynas";
  vars.kind = "workstation";
  vars.platform = "aarch64-darwin";
}
