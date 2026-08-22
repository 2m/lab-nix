{
  description = "Self-hostable watched list (movies, TV, anime, games)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs: {
    nixosModules.default = import ../../modules/watcharr/default.nix;

    formatter = builtins.mapAttrs (_system: pkgs: pkgs.nixfmt-tree) inputs.nixpkgs.legacyPackages;
  };
}
