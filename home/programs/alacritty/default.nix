{pkgs, ...}: {
  programs.alacritty = {
    enable = true;
  };
  home.file.".config/alacritty" = {
    source = ./alacritty;
    recursive = true;
  };
}
