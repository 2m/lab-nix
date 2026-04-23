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
        yq-go # Terminal `jq` for YAML
      ]
      ++ lib.optionals config.programs.zed-editor.enable [
        yaml-language-server
      ];
  };

  programs = {
    zed-editor = lib.mkIf config.programs.zed-editor.enable {
      userSettings = {
        languages = {
          YAML = {
            format_on_save = "off";
          };
        };
        lsp = {
          yaml-language-server = {
            settings = {
              yaml = {
                # Enforces alphabetical ordering of keys in maps
                keyOrdering = true;
              };
            };
          };
        };
      };
    };
  };
}
