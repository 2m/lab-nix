{
  config,
  lib,
  pkgs,
  ...
}:
{
  home = {
    packages =
      with pkgs;
      [

      ]
      ++ lib.optionals config.programs.zed-editor.enable [
        jdt-language-server
      ];
  };

  programs = {
    zed-editor = lib.mkIf config.programs.zed-editor.enable {
      userSettings = {
        languages = {
          Java = {
            language_servers = [
              "jdtls"
            ];
          };
        };
      };
      extensions = [
        "java"
      ];
    };
  };
}
