{ ... }:
{
  imports = [
    ../modules/vars.nix
  ];

  vars.fqdn = "darwix.2m.lt";
  vars.hostname = "darwix";
  vars.username = "martynas";
  vars.kind = "workstation";
  vars.platform = "aarch64-linux";
}
