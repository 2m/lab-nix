{ ... }:

{
  imports =
    [
      ./frontend.nix
      ./hardware-configuration.nix
      ./speedtest.nix
      ../modules/common.nix
      ../modules/monitoring.nix
      ../modules/network.nix
      ../modules/vars.nix
    ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;

  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  time.timeZone = "Europe/Vilnius";

  system.stateVersion = "25.11";

  vars.fqdn = "lab-rpi.2m.lt";
  vars.hostname = "lab-rpi";
}
