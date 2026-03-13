{
  pkgs,
  ...
}:
let
  fontSize = 13;
  fontWeight = 400;
in
{
  programs = {
    zed-editor = {
      enable = true;
      extensions = [
        "comment"
        "dependi"
        "dockerfile"
        "editorconfig"
        "ini"
        "make"
        "rainbow-csv"
        "scala"
        "xml"
      ];
      userSettings = {
        base_keymap = "VSCode";
        buffer_font_family = "FiraCode Nerd Font Mono";
        buffer_font_size = fontSize;
        buffer_font_weight = fontWeight;
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
          blinking = "on";
          copy_on_select = true;
          font_family = "FiraCode Nerd Font Mono";
          font_size = fontSize;
          max_scroll_history_lines = 16384;
        };
      };
    };
  };
}
