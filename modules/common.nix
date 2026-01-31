{ pkgs, ... }:

{
  time.timeZone = "Europe/Vilnius";

  environment.systemPackages = with pkgs; [
    wget
    git
    jq
    bc
    bat
    dua
    btop
  ];

  programs.fish = {
    enable = true;
    shellAliases = {
      nix-shell = "nix-shell --command fish";
    };
  };
  users.defaultUserShell = pkgs.fish;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    download-buffer-size = 524288000; # 500MB
  };

  # speedup system builds
  documentation.man.generateCaches = false;

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];
}
