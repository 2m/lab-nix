{ config, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../modules/common.nix
    ../modules/network.nix
    ./vars.nix
    ../nixos
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users."${config.vars.username}" = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = config.vars.authorizedKeys;
    extraGroups = [
      "wheel"
    ];
  };

  home-manager = {
    users."${config.vars.username}" =
      { ... }:
      {
        imports = [
          ./vars.nix
          ../home-manager
        ];

        home = {
          username = config.vars.username;
          homeDirectory = lib.mkDefault "/home/${config.vars.username}";
          # The state version is required and should stay at the version you originally installed.
          stateVersion = "26.05";
        };
      };

    backupFileExtension = "before-home-manager";
  };

  system.stateVersion = "26.05";
}
