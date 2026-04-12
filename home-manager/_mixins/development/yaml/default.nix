{
  config,
  lib,
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      yaml-language-server
      yq-go # Terminal `jq` for YAML
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
