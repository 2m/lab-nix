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
        typst
      ]
      ++ lib.optionals config.programs.zed-editor.enable [
        tinymist
      ];
  };

  programs = {
    zed-editor = lib.mkIf config.programs.zed-editor.enable {
      extensions = [
        "typst"
      ];
      userSettings = {
        languages = {
          Typst = {
            language_servers = [
              "tinymist"
            ];
            soft_wrap = "none";
          };
        };
        lsp = {
          tinymist = {
            initialization_options = {
              preview = {
                background = {
                  enabled = true;
                };
              };
            };
            settings = {
              exportPdf = "onSave";
              outputPath = "$root/$name";
              formatterMode = "typstyle";
            };
          };
        };
      };
    };
  };
}
