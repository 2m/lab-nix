{
  lib,
  ...
}:
{
  # Since both nixos and darwin systems currently use the same mixins, some of the
  # options are not available in nix-darwin. These attributes bridge the gap by
  # providing the attributes themselves, but they do nothing.

  options.users = {
    defaultUserShell = lib.mkOption {
      type = lib.types.package;
    };
  };

  options.security.sudo = {
    wheelNeedsPassword = lib.mkOption {
      type = lib.types.bool;
    };
  };
}
