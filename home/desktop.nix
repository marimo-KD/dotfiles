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
    foot
    mako
    pavucontrol
    swaybg
    wl-clipboard
    wofi
    xdg-utils
    zathura
  ];
}
