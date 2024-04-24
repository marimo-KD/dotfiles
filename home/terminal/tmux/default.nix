{pkgs, ...}: 
let term = if pkgs.stdenv.isDarwin then "alacritty" else "foot";
in
{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    keyMode = "vi";
    clock24 = true;
    shortcut = "s";
    plugins = with pkgs.tmuxPlugins; [
      catppuccin
      sensible
      pain-control
      prefix-highlight
    ];
    extraConfig = ''
      set -g mouse on
      bind C-d detach-client
      bind C-g display-panes
      set -g display-panes-time 4000
      set -ag terminal-overrides ",${term}:Tc"
      set -g @catppuccin_flavour 'latte'
      set -g @catppuccin_window_left_separator ""
      set -g @catppuccin_window_right_separator " "
      set -g @catppuccin_window_middle_separator " █"
      set -g @catppuccin_window_number_position "right"
      
      set -g @catppuccin_window_default_fill "number"
      set -g @catppuccin_window_default_text "#W"
      
      set -g @catppuccin_window_current_fill "number"
      set -g @catppuccin_window_current_text "#W"
      
      set -g @catppuccin_status_modules_right "directory user host session"
      set -g @catppuccin_status_left_separator  " "
      set -g @catppuccin_status_right_separator ""
      set -g @catppuccin_status_fill "icon"
      set -g @catppuccin_status_connect_separator "no"
      
      set -g @catppuccin_directory_text "#{pane_current_path}"
    '';
  };
}
