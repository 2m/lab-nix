{
  description = "2m systems NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-patcher.url = "github:gepbird/nixpkgs-patcher";
    # nixpkgs-patch-dawarich = {
    #   url = "https://github.com/NixOS/nixpkgs/pull/423867.diff";
    #   flake = false;
    # };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      # choose not to download darwin deps (saves some resources on Linux)
      inputs.darwin.follows = "";
    };

    jellarr.url = "github:venkyr77/jellarr";

    netalertx.url = "github:netalertx/NetAlertX?dir=install/nix";

    intel-gpu-exporter.url = "./flakes/intel-gpu-exporter";
  };

  outputs = { nixpkgs-patcher, home-manager, agenix, jellarr, netalertx, ...}@inputs: {
    nixosConfigurations = {
      lab-hb = nixpkgs-patcher.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./lab-hb/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          agenix.nixosModules.default
          jellarr.nixosModules.default
          netalertx.nixosModules.default
          inputs.intel-gpu-exporter.nixosModules.default
        ];
        specialArgs = inputs;
      };
      lab-rpi = nixpkgs-patcher.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./lab-rpi/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          agenix.nixosModules.default
        ];
        specialArgs = inputs;
      };
    };
  };
}
