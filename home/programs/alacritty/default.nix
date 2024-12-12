{pkgs, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        dynamic_padding = true;
        opacity = 0.9;
        option_as_alt = "Both";
      };
      font = {
        normal = {
          family = "UDEV Gothic 35NFLG";
        };
        size = 14;
      };
      shell = {
        program = "nu";
      };
      keyboard = {
        bindings = [
          { key = "¥"; chars = "\\\\";}
          { key = "¥"; mods = "Alt"; chars = "\\\\";}
        ];
      };
    };
  };
}
