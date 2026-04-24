{ pkgs, ... }:

{
  time.timeZone = "Europe/Vilnius";

  environment.systemPackages = with pkgs; [
    git # for pushing new nixos config
    wget
    jq
    bc
    bat
    dua
    btop
    xh
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    download-buffer-size = 524288000; # 500MB
  };

  # speedup system builds
  documentation.enable = false;
  documentation.nixos.enable = false;

  # fish enables man caches, disable it
  documentation.man.cache.enable = false;

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];
}
