{pkgs, ...}: {
  programs.waybar.enable = true;
  home.file.".config/waybar" = {
    source = ./waybar;
    recursive = true;
  };
}
