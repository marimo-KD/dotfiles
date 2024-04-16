{pkgs, ...}: 
let term = if pkgs.stdenv.isDarwin then "alacritty" else "foot"
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
    '';
  };
}
