{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./frontend.nix
    ./grafana.nix
    ./jellyfin.nix
    ./qbittorrent-exporter-module.nix
    ./victorialogs.nix
    ./victoriametrics.nix
    ../modules/common.nix
    ../modules/network.nix
    ../modules/vars.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Allow partition unlock via ssh
  boot.kernelParams = [ "ip=dhcp" ];
  boot.initrd = {
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 2222;  # Use a separate port to prevent conflict in your known hosts
        hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
        authorizedKeys = config.users.users.root.openssh.authorizedKeys.keys;
        shell = "/bin/cryptsetup-askpass";
      };
    };
    availableKernelModules = [ "r8152" "usbnet" "cdc_ether" "xhci_pci" "ehci_pci" "uhci_hcd" ];
    kernelModules = [ "r8152" "usbnet" "cdc_ether" "xhci_pci" "ehci_pci" "uhci_hcd" ];
  };

  environment.systemPackages = with pkgs; [
    intel-gpu-tools
  ];

  vars.fqdn = "lab.2m.lt";
  vars.hostname = "lab-hb";

  networking = {
    firewall = {
      allowedTCPPorts = [
        config.services.qbittorrent.torrentingPort
      ];
    };
  };

  age.secrets.qbittorrent = {
    file = ../secrets/qbittorrent.age;
    owner = config.services.qbittorrent-exporter.user;
    group = config.services.qbittorrent-exporter.group;
  };

  services = {
    thelounge.enable = true;
    calibre-web = {
      enable = true;
      options = {
        enableBookUploading = true;
        calibreLibrary = "/var/lib/calibre-library";
      };
    };
    lubelogger.enable = true;
    dawarich = {
      enable = true;
      configureNginx = false;
      localDomain = "track.${config.vars.fqdn}";
      webPort = 7000;
    };
    qbittorrent = {
      enable = true;
      package = pkgs.qbittorrent-nox;
      webuiPort = 8080;
      torrentingPort = 60413;
    };
    qbittorrent-exporter = {
      enable = true;
      environment = {
        QBITTORRENT_PASSWORD_FILE = config.age.secrets.qbittorrent.path;
      };
    };
    radarr.enable = true;
    jackett.enable = true;
    bazarr = {
      enable = true;
      # same user as radarr so bazarr can write subtitles to media dir
      user = config.services.radarr.user;
      group = config.services.radarr.group;
    };
    netalertx = {
      enable = true;
      imageTag = "26.1.17";
      backendApiUrl = "https://nax-api.${config.vars.fqdn}:443";
    };
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    autoPrune = {
      enable = true;
      flags = ["--all"];
    };
  };

  virtualisation.oci-containers = {
    backend = "docker";
  };

  home-manager.users.root = { ... }: {
    home.stateVersion = "25.11";

    programs.helix = {
      enable = true;
    };

  };

  system.stateVersion = "25.11";

  age.secrets.restic_password.file = ../secrets/restic_password.age;
  age.secrets.restic_repository.file = ../secrets/restic_repository.age;

  services.restic.backups = {
    borgbase = {
      initialize = true;
      paths = [
        "/var/lib"
      ];
      exclude = [
        "/var/lib/docker"
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

