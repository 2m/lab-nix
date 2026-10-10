{ pkgs, ... }:
let
  nixLdLibs = with pkgs; [
    stdenv.cc.cc.lib   # libstdc++, libgcc_s
    zlib
    libusb1            # openocd
    ncurses
    expat
    libxml2
    openssl
  ];
in
{
  environment.systemPackages = [ pkgs.esphome pkgs.esphome-device-builder ];

  systemd.services.esphome-device-builder = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = [ pkgs.esphome ];  # builder shells out to the CLI to compile
    environment = {
      HOME = "/var/lib/esphome";
      PLATFORMIO_CORE_DIR = "/var/lib/esphome/.platformio";
      # use nix-ld on esphome downloaded esp-idf generic linux tools
      NIX_LD = pkgs.stdenv.cc.bintools.dynamicLinker;
      NIX_LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath nixLdLibs;
    };
    serviceConfig = {
      ExecStart = "${pkgs.esphome-device-builder}/bin/esphome-device-builder /var/lib/esphome";
      StateDirectory = "esphome";
      DynamicUser = true;
      # Only this service (and its children) sees nix-ld at the generic loader path
      BindReadOnlyPaths = [
        "${pkgs.nix-ld}/libexec/nix-ld:/lib64/ld-linux-x86-64.so.2"
      ];
    };
  };

  # allow device remote builds
  networking.firewall.allowedTCPPorts = [ 6055 ];
}
