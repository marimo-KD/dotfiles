{config, pkgs, ...} : {
  imports = [
    ./hyprland
    #./sway
    ./waybar
    ./wofi
  ];
  xdg.enable = true;
  gtk = {
    enable = true;
    catppuccin = {
      enable = true;
      flavour = "frappe";
      accent = "pink";
      size = "standard";
      tweaks = [ "normal" ];
      cursor = {
        enable = true;
        flavour = "frappe";
        accent = "pink";
      };
      icon = {
        enable = true;
        flavour = "frappe";
        accent = "pink";
      };
    };
  };
  services.mako = {
    enable = true;
    catppuccin = {
      enable = true;
      flavour = "frappe";
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
    swaybg # background
    wl-clipboard # clipboard
    xdg-utils
    # zathura # pdf viewer
    # apvlv # pdf viewer
    evince # pdf viewer
    rnote # stylus note taking
  ];
}
