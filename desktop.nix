{pkgs, ...} : {
  wayland.windowManager.hyprland.enable = true;
  programs.waybar = {
    enable = true;
  };
  home.packages = with pkgs; [
    mako
    swaybg
    foot
    wofi
    xdg-desktop-portal-hyprland
  ];
}
