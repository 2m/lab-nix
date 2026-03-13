{ pkgs, ... }:
let
  soundOut = "hw:0";
in
{
  boot.kernelParams = [ "mitigations=off" ];

  environment.systemPackages = with pkgs; [
    usbutils
    #jack-example-tools
    #jackmeter
  ];

  hardware.alsa.enable = true;

  # musnix = {
  #   enable = true;
  #   rtcqs.enable = true;
  #   kernel = {
  #     realtime = true;
  #     packages = pkgs.linuxPackages_latest;
  #   };
  # };

  # powerManagement.cpuFreqGovernor = "performance";

  # services.jack = {
  #   jackd = {
  #     enable = false;
  #     extraOptions = [
  #       "-dalsa"
  #       "--device" soundOut
  #       "-r" "48000"
  #     ];
  #   };
  #   alsa.enable = false;  # bridges ALSA devices into JACK
  # };

  users.users.pwlink = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      #"jackaudio" # jackd futex permission
      "audio" # for ALSA
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdOC8PgQg6ZZG51pdVRFoihpD9a9D3e4gQKmDB/JVmh carla-31-03-2023"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

}
