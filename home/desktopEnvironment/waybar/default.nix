{pkgs, ...}: {
  programs.waybar.enable = true;
  home.files.".config/waybar" = {
    source = ./waybar;
    recursive = true;
  };
}
