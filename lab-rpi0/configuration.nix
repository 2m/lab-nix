{
  config,
  inputs,
  ...
}:
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

  image.repart.partitions."20-esp".contents = {
    "/kernel.img".source = "${config.hardware."${device}".platformFirmware}/u-boot.bin";
  };

  # Cross compile from x86_64-linux -> armv6l-linux
  nixpkgs.buildPlatform.system = "x86_64-linux";
  nixpkgs.hostPlatform.system = "armv6l-linux";

  system.stateVersion = "25.11";
}
