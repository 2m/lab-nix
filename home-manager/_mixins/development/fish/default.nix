{
  pkgs,
  config,
  ...
}:
{
  home = {
    packages = with pkgs; [
      eza
      grc
    ];
  };

  programs = {
    fish = {
      enable = true;
      shellAliases = {
        nix-shell = "nix-shell --command fish";
        l = "eza -bghl --sort newest --git";
        la = "l -a";
      };
      shellInit = ''
        export GPG_TTY="$(tty)"

        set --global hydro_symbol_prompt "${config.vars.promptChar}"
      '';
      plugins = [
        # colorize most of the default unix tool outputs
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
        # async git aware prompt
        {
          name = "hydro";
          src = pkgs.fishPlugins.hydro.src;
        }
      ];
    };
  };
}
