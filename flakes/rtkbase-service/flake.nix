{
  description = "rtkbase webapp";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs: {
    nixosModules.default = import ../../modules/rtkbase/default.nix;

    formatter = builtins.mapAttrs (_system: pkgs: pkgs.nixfmt-tree) inputs.nixpkgs.legacyPackages;
  };
}
