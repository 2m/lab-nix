{
  description = "2m systems NixOS configuration";

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

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

    intel-gpu-exporter = {
      url = "./flakes/intel-gpu-exporter";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    mikrotik-exporter = {
      url = "./flakes/mikrotik-exporter";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    betula-service = {
      url = "./flakes/betula-service";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";

    musnix.url = "github:musnix/musnix";

    flake-utils.url = "github:numtide/flake-utils";

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae.url = "github:vicinaehq/vicinae";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    nixpkgs-patcher.url = "github:gepbird/nixpkgs-patcher";
    # nixpkgs-patch-cook-cli = {
    #   url = "https://github.com/NixOS/nixpkgs/pull/527569.diff";
    #   flake = false;
    # };
  };

  outputs =
    {
      nixpkgs-patcher,
      home-manager,
      agenix,
      jellarr,
      ...
    }@inputs:
    {

      nixosConfigurations = {
        lab-hb = nixpkgs-patcher.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./lab-hb/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [ agenix.homeManagerModules.default ];
            }
            agenix.nixosModules.default
            jellarr.nixosModules.default
            inputs.intel-gpu-exporter.nixosModules.default
            inputs.betula-service.nixosModules.default
          ];
          specialArgs = inputs;
        };
        darwix = nixpkgs-patcher.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./darwix/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [
                agenix.homeManagerModules.default
                inputs.niri.homeModules.niri
                inputs.vicinae.homeManagerModules.default
                inputs.noctalia.homeModules.default
                inputs.nix-colors.homeManagerModules.default
              ];
            }
            agenix.nixosModules.default
            {
              nixpkgs.overlays = [
                inputs.alacritty-theme.overlays.default
              ];
            }
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
            inputs.mikrotik-exporter.nixosModules.default
          ];
          specialArgs = inputs;
        };
        lab-rpi3 = nixpkgs-patcher.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            inputs.musnix.nixosModules.musnix
            ./lab-rpi3/configuration.nix
          ];
          specialArgs = inputs;
        };
      };

      darwinConfigurations."carla" = inputs.nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./carla/configuration.nix
          inputs.determinate.darwinModules.default
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [ agenix.homeManagerModules.default ];
          }
          agenix.nixosModules.default
          {
            nixpkgs.overlays = [
              inputs.alacritty-theme.overlays.default
            ];
          }
        ];
        specialArgs = inputs;
      };
    }
    // inputs.flake-utils.lib.eachDefaultSystem (system: {
      formatter = inputs.nixpkgs.legacyPackages.${system}.nixfmt-tree;
    });
}
