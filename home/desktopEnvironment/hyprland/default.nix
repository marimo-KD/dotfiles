{pkgs, config,...}: {
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    settings = {
      input = {
        kb_layout = "us";
        kb_model = "pc104";
        follow_mouse = 2;
      };
      general = {
        gaps_in = 2;
        gaps_out = 5;
        border_size = 0;
        no_border_on_floating = false;
        layout = "dwindle";
      };
      cursor = {
        no_warps = true;
      };
      dwindle = {
        preserve_split = true;
      };
      animations = {
        enabled = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };
      "$mainMod" = "SUPER";
      "$term" = "foot";
      bind = [
        "$mainMod, Return, exec, $term"
        "$mainMod SHIFT, Q, killactive"
        "$mainMod SHIFT, E, exec, wlogout"
        "$mainMod, f, fullscreen"
        "$mainMod, Space, togglefloating"
        "$mainMod, d, exec, wofi --show drun"
        "$mainMod, x, exec, pkill -SIGUSR1 waybar"
        "$mainMod, s, togglesplit"

        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, j, movewindow, d"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      exec-once = [
        "mako"
        "fcitx5 -rd"
        "lxqt-policykit-agent"
      ];
      windowrulev2 = [
        "float,class:^(pavucontrol)$"
        "float,title:^(Media viewer)$"
        "float,title:^(Volume Control)$"
        "float,title:^(Picture-in-Picture)$"
        "float,class:^(file_progress)$"
        "float,class:^(confirm)$"
        "float,class:^(dialog)$"
        "float,class:^(download)$"
        "float,class:^(notification)$"
        "float,class:^(error)$"
        "float,title:^(Open File)$"
        "float,title:^(File Operation Progress)"
        "float,class:(emacs),title:(filechooser-frame)"
        "float,class:(emacs),title:(filechooser-miniframe)"

        "move 75 44%,title:^(Volume Control)$"
        "size 800 600,class:^(download)$"
        "size 800 600,title:^(Open File)$"
        "size 800 600,title:^(Save File)$"
        "size 800 600,title:^(Volume Control)$"
      ];
    };
  };
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
  home.packages = with pkgs; [
    # hyprpolkitagent # graphical polkit agent
    lxqt.lxqt-policykit
  ];
}
