{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  device = "bcm2835-rpi-zero-w";
  raspberryPiBootFirmware = pkgs.runCommand "raspberrypi-boot-firmware-without-kernels" { } ''
    cp -r ${pkgs.raspberrypifw}/share/raspberrypi/boot $out
    chmod -R u+w $out
    rm -f $out/config.txt $out/cmdline.txt $out/kernel*.img $out/initramfs*
  '';
in
{
  imports = [
    inputs.matthew-hardware.nixosModules."${device}"
  ];

  hardware."${device}" = {
    enable = true;
    image.repart.enable = true;
  };

  image.repart.partitions."20-esp".contents."/".source = lib.mkForce raspberryPiBootFirmware;

  # Cross compile from x86_64-linux -> armv6l-linux
  nixpkgs.buildPlatform.system = "x86_64-linux";
  nixpkgs.hostPlatform.system = "armv6l-linux";

  system.stateVersion = "25.11";
}
