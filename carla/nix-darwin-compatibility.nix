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

  options.hardware.graphics = {
    enable = lib.mkOption {
      type = lib.types.bool;
    };
  };

  options.xdg.portal = {
    enable = lib.mkOption {
      type = lib.types.bool;
    };

    xdgOpenUsePortal = lib.mkOption {
      type = lib.types.bool;
    };

    config.common.default = lib.mkOption {
      type = lib.types.str;
    };

    extraPortals = lib.mkOption {
      type = lib.types.listOf lib.types.package;
    };
  };

  options.security.rtkit = {
    enable = lib.mkOption {
      type = lib.types.bool;
    };
  };

  options.services.pipewire = {
    enable = lib.mkOption {
      type = lib.types.bool;
    };

    alsa = {
      enable = lib.mkOption {
        type = lib.types.bool;
      };
    };

    pulse = {
      enable = lib.mkOption {
        type = lib.types.bool;
      };
    };
  };
}
