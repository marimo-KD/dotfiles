{config, pkgs, ...} : {
  imports = [
    ./hyprland
    #./sway
    ./waybar
    ./wofi
  ];
  xdg.enable = true;
  home.packages = with pkgs; [
    simple-scan # scanner
    grim # screenshot
    mako # notification
    pavucontrol # pipewire control gui
    slurp # tool for screenshot
    swaybg # background
    wl-clipboard # clipboard
    xdg-utils
    zathura # pdf viewer
    apvlv # pdf viewer
    rnote # stylus note taking
  ];

}
