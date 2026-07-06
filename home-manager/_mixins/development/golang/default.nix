{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf config.vars.is.workstation {
  home = {
    packages = with pkgs; [
      delve
      go
      go-licenses
      golangci-lint
      golangci-lint-langserver
      gopls
      goreleaser
      gotools
      govulncheck
    ];
    sessionPath = [
      "${config.home.homeDirectory}/.local/go/bin"
    ];
    sessionVariables = {
      GOBIN = "${config.home.homeDirectory}/.local/go/bin";
      GOCACHE = "${config.home.homeDirectory}/.local/go/cache";
      GOPATH = "${config.home.homeDirectory}/.local/go";
    };
  };

  programs = {
    zed-editor = lib.mkIf config.programs.zed-editor.enable {
      extensions = [
        "golangci-lint"
        "gosum"
      ];
      userSettings = {
        languages = {
          Go = {
            formatter = {
              external = {
                command = "gofmt";
                arguments = [ ];
              };
            };
            language_servers = [
              "gopls"
              "golangci-lint-langserver"
            ];
          };
        };
        lsp = {
          gopls = { };
          golangci-lint-langserver = { };
        };
      };
    };
  };
}
