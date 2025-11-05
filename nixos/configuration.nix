{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./gandicloud.nix
    ./frontend.nix
    ./grafana.nix
    ./victoriametrics.nix
    ./victorialogs.nix
    "${builtins.fetchTarball "https://github.com/ryantm/agenix/archive/main.tar.gz"}/modules/age.nix"
  ];

  environment.systemPackages = with pkgs; [
    bat
    neovim
    btop
    tailscale
    dua
    git
  ];

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  networking.firewall = {
    enable = true;

    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];

    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port ];

    # let you SSH in over the public internet
    allowedTCPPorts = [ 22 ];
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];

  services = {
    tailscale.enable = true;
    thelounge.enable = true;
    calibre-web = {
      enable = true;
      options = {
        enableBookUploading = true;
        calibreLibrary = "/var/lib/calibre-library";
      };
    };
  };

  age.secrets.restic_password.file = ./secrets/restic_password.age;
  age.secrets.restic_repository.file = ./secrets/restic_repository.age;

  services.restic.backups = {
    borgbase = {
      initialize = true;
      paths = [
        "/var/lib"
      ];
      passwordFile = config.age.secrets.restic_password.path; # encryption
      repositoryFile = config.age.secrets.restic_repository.path;

      timerConfig = {
        # when to backup
        OnCalendar = "00:05";
        RandomizedDelaySec = "5h";
      };
    };
  };
}
