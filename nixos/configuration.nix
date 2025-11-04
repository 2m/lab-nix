{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./gandicloud.nix
    "${builtins.fetchTarball "https://github.com/ryantm/agenix/archive/main.tar.gz"}/modules/age.nix"
  ];

  environment.systemPackages = with pkgs; [
    bat
    neovim
    btop
    tailscale
    dua
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

  services.caddy = {
    enable = true;
    virtualHosts."http://lab.2m.lt".extraConfig = ''
      header Content-Type text/html
      respond "
        <h3>Welcome to the 2m lab</h3>
        <dl>
          <dt><a href='http://irc.2m.lt'>http://irc.2m.lt</a></dt>
          <dd>The Lounge IRC Web client</dd>
          <dt><a href='http://books.2m.lt'>http://books.2m.lt</a></dt>
          <dd>Calibre Web book library</dd>
        </dl>
      "
    '';
    virtualHosts."http://irc.2m.lt".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.thelounge.port}
    '';
    virtualHosts."http://books.2m.lt".extraConfig = ''
      reverse_proxy http://localhost:${toString config.services.calibre-web.listen.port}
    '';
  };

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
