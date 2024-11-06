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
    # catppuccin = {
    #   enable = true;
    #   size = "standard";
    #   tweaks = [ "normal" ];
    #   icon = {
    #     enable = true;
    #   };
    # };
  };
    catppuccin.pointerCursor.enable = true;
  services.mako = {
    enable = true;
    catppuccin = {
      enable = true;
    };
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-skk
      fcitx5-gtk
    ];
  };
  home.file.".config/libskk" = {
    source = ./libskk;
    recursive = true;
  };
  home.packages = with pkgs; [
    simple-scan # scanner
    grim # screenshot
    mako # notification
    pavucontrol # pipewire control gui
    slurp # screenshot
    # swaybg # background
    wl-clipboard # clipboard
    xdg-utils
    # zathura # pdf viewer
    # apvlv # pdf viewer
    evince # pdf viewer
    # rnote # stylus note taking
  ];
}
