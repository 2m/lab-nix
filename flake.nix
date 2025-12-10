{
  description = "lab-hb NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-patcher.url = "github:gepbird/nixpkgs-patcher";
    nixpkgs-patch-dawarich = {
      url = "https://github.com/NixOS/nixpkgs/pull/423867.diff";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      # choose not to download darwin deps (saves some resources on Linux)
      inputs.darwin.follows = "";
    };
  };

  outputs = { nixpkgs-patcher, home-manager, agenix, ...}@inputs: {
    nixosConfigurations.lab-hb = nixpkgs-patcher.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
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
}
