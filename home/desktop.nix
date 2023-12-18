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

  programs.obs-studio = {
    enable = true;
  };
  home.packages = with pkgs; [
    simple-scan # scanner
    lapce # editor
    neovide # neovim gui
    discord 
    slack
    obsidian
    foot # terminal emulater
    grim # screenshot
    mako # notification
    pavucontrol # pipewire control gui
    slurp # tool for screenshot
    swaybg # background
    wl-clipboard # clipboard
    wofi # launcher
    xdg-utils
    zathura # pdf viewer
  ];

  # discord
  home.file.".config/discord/settings.json".text = ''
    {
      "SKIP_HOST_UPDATE": true
    }
  '';
}
