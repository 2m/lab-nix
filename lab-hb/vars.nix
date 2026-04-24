{ ... }:
{
  imports = [
    ../modules/vars.nix
  ];

  vars.fqdn = "lab.2m.lt";
  vars.hostname = "lab-hb";
  vars.username = "martynas";
  vars.kind = "server";
  vars.platform = "x86_64-linux";
}
