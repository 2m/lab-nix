{ ... }:
{
  imports = [
    ../modules/vars.nix
  ];

  vars.fqdn = "lab-rpi.2m.lt";
  vars.hostname = "lab-rpi";
  vars.username = "martynas";
  vars.kind = "server";
  vars.platform = "aarch64-linux";
}
