{
  pkgs,
  config,
  lib,
  ...
}:
let
  fontSize = 12;
  fontWeight = 400;

  uiFontSize = 16;
in
{
  programs = {
    zed-editor = lib.mkIf config.vars.is.workstation {
      enable = true;
      extensions = [
        "comment"
        "dependi"
        "dockerfile"
        "editorconfig"
        "ini"
        "make"
        "rainbow-csv"
        "xml"
      ];
      userSettings = {
        base_keymap = "VSCode";
        buffer_font_family = "FiraCode Nerd Font Mono";
        buffer_font_size = fontSize;
        buffer_font_weight = fontWeight;
        ui_font_size = uiFontSize;
        colorize_brackets = true;
        tabs = {
          file_icons = true;
        };
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
        terminal = {
          shell = {
            program = "${pkgs.fish}/bin/fish";
          };
          blinking = "off";
          copy_on_select = false;
          font_family = "FiraCode Nerd Font Mono";
          font_size = fontSize;
          max_scroll_history_lines = 16384;
        };
        theme = {
          mode = "dark";
          dark = "Gruvbox Dark Soft";
          light = "Gruvbox Light Hard";
        };
        icon_theme = {
          mode = "dark";
          light = "Zed (default)";
          dark = "Zed (default)";
        };
        edit_predictions = {
          mode = "subtle";
        };
        autosave = "on_focus_change";
      };
      userKeymaps =
        # control characters from https://en.wikipedia.org/wiki/ASCII#ASCII_control_characters
        let
          chars = [
            "a"
            "c"
            "d"
            "e"
            "u"
            "w"
          ];
          bindings = builtins.listToAttrs (
            map (char: {
              name = "cmd-${char}";
              value = [
                "terminal::SendKeystroke"
                "ctrl-${char}"
              ];
            }) chars
          );
        in
        [
          {
            context = "Terminal";
            inherit bindings;
          }
          # navigation across history
          {
            context = "Editor";
            bindings = {
              "cmd-[" = "pane::GoBack";
              "cmd-]" = "pane::GoForward";
            };
          }
          # moving/selecting words with command+arrows
          {
            context = "Editor";
            bindings = {
              "cmd-right" = "editor::MoveToNextWordEnd";
              "cmd-left" = "editor::MoveToPreviousWordStart";
              "cmd-shift-right" = "editor::SelectToNextWordEnd";
              "cmd-shift-left" = "editor::SelectToPreviousWordStart";
            };
          }
          {
            context = "Terminal";
            bindings = {
              "cmd-right" = [
                "terminal::SendKeystroke"
                "alt-right"
              ];
              "cmd-left" = [
                "terminal::SendKeystroke"
                "alt-left"
              ];
            };
          }
          # copy/paste from/into terminal with shift as well
          {
            context = "Terminal";
            bindings = {
              "cmd-shift-c" = "terminal::Copy";
              "cmd-shift-v" = "terminal::Paste";
            };
          }
          # toggle focus between editor and terminal
          {
            context = "Editor";
            bindings = {
              "cmd-`" = "terminal_panel::ToggleFocus";
            };
          }
        ];
    };
  };
}
