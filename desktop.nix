{pkgs, ...} : {
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
  };
  programs.waybar = {
    enable = true;
  };
  home.file.".config/hypr" = {
    source = ./hypr;
    recursive = true;
  };
  home.packages = with pkgs; [
    mako
    swaybg
    foot
    wofi
  ];
}
