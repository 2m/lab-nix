{
  config,
  lib,
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      metals
      scala-cli
    ];
  };

  programs = {
    zed-editor = lib.mkIf config.programs.zed-editor.enable {
      userSettings = {
        languages = {
          Scala = {
            language_servers = [
              "metals"
            ];
          };
        };
        lsp = {
          metals = {
            binary = {
              arguments = [
                "-Dmetals.http=on"
              ];
            };
            initialization_options = {
              isHttpEnabled = true;
            };
            settings = {
              autoImportBuilds = "all";
            };
            format_on_save = "on";
          };
        };
      };
      extensions = [
        "metals-zed"
      ];
    };
  };
}
