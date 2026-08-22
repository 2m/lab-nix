{
  config,
  lib,
  ...
}:
{
  programs = {
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
    devenv = {
      enable = true;
    };
    zed-editor = lib.mkIf config.programs.zed-editor.enable {
      userSettings = {
        load_direnv = "shell_hook";
      };
    };
  };
}
