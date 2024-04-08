{pkgs,...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  home.file.".config/hypr" = {
    source = ./hypr;
    recursive = true;
  };
}
