{pkgs, ...} : {
  wayland.windowManager.hyprland.enable = true;
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
    xdg-desktop-portal-hyprland
  ];
}
