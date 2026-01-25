{ ... }:
{
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
      keys.insert = {
        "C-n" = "move_line_down";
        "C-p" = "move_line_up";
        "C-f" = "move_char_right";
        "C-b" = "move_char_left";
        "C-e" = "goto_line_end_newline";
        "C-a" = "goto_line_start";
      };
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
      editor.whitespace = {
        render = {
          tab = "all";
        };
        characters = {
          tab = "→";
        };
      };
      editor.indent-guides = {
        render = true;
        skip-levels = 1;
      };
    };
  };
}
