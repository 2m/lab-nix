{ inputs, ... }:
let
  device = "bcm2835-rpi-zero-w";
in
{
  imports = [
    inputs.matthew-hardware.nixosModules."${device}"
  ];

  hardware."${device}" = {
    enable = true;
    image.repart.enable = true;
  };

  # Cross compile from aarch64-linux -> armv6l-linux
  nixpkgs.buildPlatform.system = "x86_64-linux";
  nixpkgs.hostPlatform.system = "armv6l-linux";
}
