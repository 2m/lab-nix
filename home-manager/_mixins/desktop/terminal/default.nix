{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs = {
    alacritty = lib.mkIf config.vars.is.workstation {
      enable = true;
      settings = {
        general.import = with pkgs; [ alacritty-theme.gruvbox_dark ];
        terminal = {
          shell = {
            program = "${pkgs.fish}/bin/fish";
          };
        };
        font = {
          size = 13;
          normal = {
            family = "FiraCode Nerd Font";
          };
        };
        window = {
          decorations = "none";
          padding = {
            x = 2;
            y = 2;
          };
        };
        selection = {
          save_to_clipboard = false;
          semantic_escape_chars = ",│`|:\"' ()[]{}<>";
        };
        keyboard = {
          bindings = [
            {
              action = "Paste";
              key = "V";
              mods = "Command|Shift";
            }
            {
              action = "Copy";
              key = "C";
              mods = "Command|Shift";
            }
            {
              chars = builtins.fromJSON ''"\u0001" '';
              key = "A";
              mods = "Command";
            }
            {
              chars = builtins.fromJSON ''"\u0003" '';
              key = "C";
              mods = "Command";
            }
            {
              chars = builtins.fromJSON ''"\u0004" '';
              key = "D";
              mods = "Command";
            }
            {
              chars = builtins.fromJSON ''"\u0005" '';
              key = "E";
              mods = "Command";
            }
            {
              chars = builtins.fromJSON ''"\u0015" '';
              key = "U";
              mods = "Command";
            }
            {
              chars = builtins.fromJSON ''"\u0017" '';
              key = "W";
              mods = "Command";
            }
          ];
        };
      };
    };
  };
}
