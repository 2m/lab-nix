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
        just
      ]
      ++ lib.optionals config.programs.zed-editor.enable [
        just-formatter
        just-lsp
      ];
  };

  programs = {
    zed-editor = lib.mkIf config.programs.zed-editor.enable {
      extensions = [
        "just"
        "just-ls"
      ];
      userSettings = {
        languages = {
          Just = {
            formatter = {
              external = {
                command = "${pkgs.just-formatter}/bin/just-formatter";
              };
            };
            language_servers = [
              "just-lsp"
            ];
          };
        };
        lsp = {
          just-lsp = { };
        };
      };
    };
  };
}
