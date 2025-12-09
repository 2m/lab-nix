{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
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

  networking.hostName = "lab2m";
  networking.networkmanager.enable = true;
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  time.timeZone = "Europe/Vilnius";

  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdOC8PgQg6ZZG51pdVRFoihpD9a9D3e4gQKmDB/JVmh carla-31-03-2023"
  ];

  environment.systemPackages = with pkgs; [
    wget
    git
    intel-gpu-tools
    jq
    bc
  ];

  programs.fish = {
    enable = true;
    shellAliases = {
      nix-shell = "nix-shell --command fish";
    };
  };
  users.defaultUserShell = pkgs.fish;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.openssh.enable = true;

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
}

