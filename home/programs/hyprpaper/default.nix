{pkgs, config, ...}: {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "${config.home.homeDirectory}/Pictures/wallpaper/pink.png"
      ];
      wallpaper = [
        "HDMI-A-1,${config.home.homeDirectory}/Pictures/wallpaper/pink.png"
      ];
    };
  };
}
