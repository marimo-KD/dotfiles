{config, pkgs, ...} : {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.waybar = {
    enable = true;
  };
  xdg.enable = true;
  home.file.".config/hypr" = {
    source = ./hypr;
    recursive = true;
  };
  home.packages = with pkgs; [
    pavucontrol
    mako
    swaybg
    foot
    wofi
  ];
}
