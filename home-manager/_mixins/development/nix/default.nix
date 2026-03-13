{
  config,
  lib,
  pkgs,
  ...
}:
{
  home = {
    packages = with pkgs; [
      deadnix
      nixd
      nix-diff
      nixfmt
      nixfmt-tree
      statix
    ];
  };

  programs = {
    zed-editor = lib.mkIf config.programs.zed-editor.enable {
      userSettings = {
        languages = {
          Nix = {
            formatter = {
              external = {
                command = "${pkgs.nixfmt}/bin/nixfmt";
                arguments = [
                  "--quiet"
                  "--"
                ];
              };
            };
            language_servers = [
              "nixd"
            ];
          };
        };
        lsp = {
          nixd = {
            settings = {
              diagnostics = {
                suppress = [ "sema-extra-with" ];
              };
            };
          };
        };
      };
      extensions = [
        "nix"
      ];
    };
  };
}
