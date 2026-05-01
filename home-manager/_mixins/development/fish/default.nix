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
      functions = {
        # Override hydro's fish_prompt to use printf instead of echo, which avoids
        # appending a trailing newline. VS Code's shell integration calls the prompt
        # function inline (not in a command substitution), so fish's normal
        # trailing-newline stripping doesn't apply — causing an extra blank line.
        fish_prompt = {
          description = "Hydro";
          body = ''
            printf '%s' "$_hydro_color_start$hydro_symbol_start$hydro_color_normal$_hydro_color_pwd$_hydro_pwd$hydro_color_normal $_hydro_color_git$$_hydro_git$hydro_color_normal$_hydro_color_duration$_hydro_cmd_duration$hydro_color_normal$_hydro_status$hydro_color_normal "
          '';
        };
      };
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
