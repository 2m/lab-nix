{ pkgs, ... }:

{
  time.timeZone = "Europe/Vilnius";

  environment.systemPackages = with pkgs; [
    wget
    jq
    bc
    bat
    dua
    btop
    eza
    xh
  ];

  users.defaultUserShell = pkgs.fish;

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
