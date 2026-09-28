{
  description = "2m systems NixOS configuration";

  inputs = {
    determinate = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jellarr = {
      url = "github:venkyr77/jellarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    intel-gpu-exporter = {
      url = "./flakes/intel-gpu-exporter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mikrotik-exporter = {
      url = "./flakes/mikrotik-exporter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rtkbase-service = {
      url = "./flakes/rtkbase-service";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    watcharr = {
      url = "./flakes/watcharr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alacritty-theme = {
      url = "github:alexghr/alacritty-theme.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae = {
      url = "github:vicinaehq/vicinae";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors = {
      url = "github:misterio77/nix-colors";
    };

    nixpkgs-patcher.url = "github:gepbird/nixpkgs-patcher";
    # nixpkgs-patch-meilisearch = {
    #   url = "https://github.com/NixOS/nixpkgs/pull/549487.diff";
    #   flake = false;
    # };

    matthew-hardware = {
      url = "git+https://codeberg.org/matthewcroughan/matthew-hardware.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chirpstack = {
      url = "github:2m/blazing-cluster/fix/chirpstack-flake-2m?dir=flakes/chirpstack-network-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    {
      nixosConfigurations = {
        lab-hb = inputs.nixpkgs-patcher.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./lab-hb/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [ inputs.agenix.homeManagerModules.default ];
            }
            inputs.agenix.nixosModules.default
            inputs.jellarr.nixosModules.default
            inputs.intel-gpu-exporter.nixosModules.default
            inputs.watcharr.nixosModules.default
          ];
          specialArgs = inputs;
        };
        darwix = inputs.nixpkgs-patcher.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./darwix/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [
                inputs.agenix.homeManagerModules.default
                inputs.niri.homeModules.niri
                inputs.vicinae.homeManagerModules.default
                inputs.noctalia.homeModules.default
                inputs.nix-colors.homeManagerModules.default
              ];
            }
            inputs.agenix.nixosModules.default
            {
              nixpkgs.overlays = [
                inputs.alacritty-theme.overlays.default
              ];
            }
          ];
          specialArgs = inputs;
        };
        lab-rpi = inputs.nixpkgs-patcher.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./lab-rpi/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
            }
            inputs.agenix.nixosModules.default
            inputs.mikrotik-exporter.nixosModules.default
            inputs.rtkbase-service.nixosModules.default
            inputs.chirpstack.nixosModules.chirpstack-network-server
            inputs.chirpstack.nixosModules.chirpstack-gateway-bridge
          ];
          specialArgs = inputs;
        };
        lab-rpi3 = inputs.nixpkgs-patcher.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            inputs.musnix.nixosModules.musnix
            ./lab-rpi3/configuration.nix
          ];
          specialArgs = inputs;
        };
        lab-rpi0 = inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            ./lab-rpi0/configuration.nix
          ];
          specialArgs = { inherit inputs; };
        };
      };

      darwinConfigurations."carla" = inputs.nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./carla/configuration.nix
          inputs.determinate.darwinModules.default
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [ inputs.agenix.homeManagerModules.default ];
          }
          inputs.agenix.nixosModules.default
          {
            nixpkgs.overlays = [
              inputs.alacritty-theme.overlays.default
            ];
          }
        ];
        specialArgs = inputs;
      };

      formatter = builtins.mapAttrs (_system: pkgs: pkgs.nixfmt-tree) inputs.nixpkgs.legacyPackages;
    };
}
