{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    style = ./style.css;
    systemd = {
      enable = true;
    };
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        exclusive = false;
        passthrough = false;
        height = 35;
        margin-top = 5;
        margin-bottom = 10;
        output = [ "HDMI-A-1" ];
        modules-center = [
          "custom/launcher"
          "hyprland/workspaces"
          "wireplumber"
          "network"
          "cpu"
          "memory"
          "temperature"
          "tray"
          "clock"
          "custom/power"
        ];
        "custom/launcher" = {
          format = " ";
          on-click = "nwg-drawer";
          on-click-right = "killall nwg-drawer";
        };
        "hyprland/workspaces" = {
          active-only = false;
          all-outputs = true;
          disable-scroll = false;
          on-scroll-up = "hyprctl dispatch workspace e-1";
          on-scroll-down = "hyprctl dispatch workspace e+1";
          on-click = "activate";
          format = "{id}";
        };
        "wireplumber" = {
          format = "{volume}% {icon}";
          format-muted = "";
          format-icons = ["" "" ""];
          on-click = "pwvucontrol";
        };
        "network" = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "Connected  ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };
        "cpu" = {
          format = "{usage}% ";
          tooltip = false;
        };
        "memory" = {
          format = "{}% ";
        };
        "temperature" = {
          format = "{temperatureC}°C {icon}";
          format-icons = ["" "" ""];
        };
        "keyboard-state" = {
          numlock = true;
          capslock = true;
          format = " {name} {icon}";
          format-icons = {
            "locked" = "";
            "unlocked" = "";
          };
        };
        "tray" = {
          icon-size = 20;
          spacing = 10;
        };
        "clock" = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };
        "custom/power" = {
          format = " ";
          on-click = "wlogout";
        };
      };
    };
  };
  home.packages = with pkgs; [
    nwg-drawer
    pwvucontrol
  ];
}
