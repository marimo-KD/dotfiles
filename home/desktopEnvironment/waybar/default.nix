{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    style = ./style.css;
    catppuccin = {
      enable = true;
      mode = "createLink";
    };
    settings = {
      mainBar = {
        layer = "top";
        position = "left";
        width = 30;
        margin = "5 0 5 2";
        output = [ "HDMI-A-1" ];
        # upper side
        modules-left = [
          "hyprland/workspaces"
          "hyprland/submap"
        ];
        modules-center = [];
        modules-right = [
          "tray"
          "group/sound"
          "group/connection"
          "clock"
        ];
        "hyprland/workspaces" = {
          active-only = false;
          all-outputs = true;
          disable-scroll = false;
          on-scroll-up = "hyprctl dispatch workspace e-1";
          on-scroll-down = "hyprctl dispatch workspace e+1";
          on-click = "activate";
          format = "{name}";
          sort-by-number = true;
        };
        "tray" = {
          icon-size = 18;
          spacing = 10;
        };
        "group/sound" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 500;
            transition-left-to-right = false;
          };
          modules = [
            "pulseaudio"
            "pulseaudio#mic"
            "pulseaudio/slider"
          ];
        };
        "pulseaudio" = {
          format = "{icon}";
          format-bluetooth = "{icon}";
          tooltip-format = "{volume}% {icon} | {desc}";
          format-muted = "󰖁";
          format-icons = {
            headphone = "󰋌";
            handsfree = "󰋌";
            headset = "󰋌";
            phone = "";
            portable = "";
            car = " ";
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-middle = "pavucontrol";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          smooth-scrolling-threshold = 1;
        };
        "pulseaudio#mic" = {
          format = "{format_source}";
          format-source = "";
          format-source-muted = "";
          tooltip-format = "{volume}% {format_source} ";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          on-scroll-up = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1%-";
        };
        "pulseaudio/slider" = {
          min = 0;
          max = 110;
          orientation = "vertical";
        };
        "group/connection" = {
          orientation = "inherit";
          modules = [
            "group/network"
            "group/bluetooth"
          ];
        };
        "group/network" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 500;
            transition-left-to-right = false;
          };
          modules = [
            "network"
            "network#speed"
          ];
        };
        "network" = {
          format = "{icon}";
          format-icons = {
            wifi = "󰤨";
            ethernet = "󰈀";
            disconnected = "󰖪";
          };
          format-wifi = "󰤨";
          format-ethernet = "󰈀";
          format-disconnected = "󰖪";
          format-linked = "󰈁";
          tooltip = false;
        };
        "network#speed" = {
          format = " {bandwidthDownBits} ";
          rotate = 90;
          interval = 5;
          tooltip = true;
          tooltip-format = "{ipaddr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)   \n{ipaddr} | {frequency} MHz{icon} ";
          tooltip-format-ethernet = "{ifname} 󰈀 \n{ipaddr} | {frequency} MHz{icon} ";
          tooltip-format-disconnected = "Not Connected to any type of Network";
        };
        "group/bluetooth" = {
          orientation = "inherit";
          drawer = {
            transition-duration = 500;
            transition-left-to-right = false;
          };
          modules = [
            "bluetooth"
            "bluetooth#status"
          ];
        };
        "bluetooth" = {
          format-on = "";
          format-off = "󰂲";
          format-disabled = "";
          format-connected = "<b></b>";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
        };
        "bluetooth#status" = {
          format-on = "";
          format-off = "";
          format-disabled = "";
          format-connected = "<b>{num_connections}<\b>";
          format-connected-battery = "<small><b>{device_battery_percentage}%</b></small>";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
        };
        "clock" = {
          format = "{:%H\n%M}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "month";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
          };
        };
      };
    };
  };
}
