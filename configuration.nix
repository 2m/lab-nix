{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./frontend.nix
    ./grafana.nix
    ./network.nix
    ./victorialogs.nix
    ./victoriametrics.nix
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

  time.timeZone = "Europe/Vilnius";

  environment.systemPackages = with pkgs; [
    wget
    git
    intel-gpu-tools
    jq
    bc
    bat
    dua
  ];

  programs.fish = {
    enable = true;
    shellAliases = {
      nix-shell = "nix-shell --command fish";
    };
  };
  users.defaultUserShell = pkgs.fish;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # speedup system builds
  documentation.man.generateCaches = false;

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024;
    }
  ];

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
      localDomain = "track.2m.lt";
      webPort = 7000;
    };
  };

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };

  home-manager.users.root = { pkgs, ... }: {
    home.stateVersion = "25.11";

    programs.helix = {
      enable = true;
    };

  };

  system.stateVersion = "25.11";

  age.secrets.restic_password.file = ./secrets/restic_password.age;
  age.secrets.restic_repository.file = ./secrets/restic_repository.age;

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

