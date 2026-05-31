{
  lib,
  ...
}:
{
  # Since both nixos and darwin systems currently use the same mixins, some of the
  # options are not available in nix-darwin. These attributes bridge the gap by
  # providing the attributes themselves, but they do nothing.

  options.programs.niri = {
    enable = lib.mkOption {
      type = lib.types.bool;
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
    };
  };
}
