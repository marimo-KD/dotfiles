{config, pkgs, ...} : {
  imports = [
    ./hyprland
    #./sway
    ./waybar
    ./wofi
    ./gnome
  ];
  systemd.user.settings.DefaultEnvironment = {
    PATH = "/run/current-system/sw/bin";
  };
  gtk = {
    enable = true;
  };
  services.mako = {
    enable = true;
  };
  home.file.".config/libskk" = {
    source = ./libskk;
    recursive = true;
  };
  programs.wlogout = {
    enable = true;
  };
  home.packages = with pkgs; [
    nwg-drawer # launcher(drawer)
    simple-scan # scanner
    grim # screenshot
    mako # notification
    # pavucontrol # pipewire control gui
    pwvucontrol
    slurp # screenshot
    # swaybg # background
    wl-clipboard # clipboard
    xdg-utils
    zathura # pdf viewer
    # apvlv # pdf viewer
    # evince # pdf viewer
    # rnote # stylus note taking
  ];
}
