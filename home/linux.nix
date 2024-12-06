{pkgs, ...}: {
  home = rec {
    username = "marimo";
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
    sessionVariables = {
      WINEFSYNC = 1;
    };
  };
  programs.home-manager.enable = true;
  imports = [
    ./programs/bash
    ./programs/bat
    ./programs/carapace
    ./programs/direnv
    ./programs/discord
    ./programs/emacs
    ./programs/fd
    ./programs/firefox
    ./programs/foot
    ./programs/fzf
    ./programs/git
    ./programs/gpg
    ./programs/hyprland
    ./programs/hyprpaper
    ./programs/latex
    ./programs/mako
    ./programs/mpd
    ./programs/neovim
    ./programs/nushell
    ./programs/obs-studio
    ./programs/ripgrep
    ./programs/starship
    ./programs/waybar
    ./programs/wlogout
    ./programs/wofi
    ./programs/zoxide

    ./packages.nix
  ];
  systemd.user.settings.DefaultEnvironment = {
    PATH = "/run/current-system/sw/bin";
  };
  home.packages = with pkgs; [
    simple-scan # scanner
    wl-clipboard # clipboard
    sioyek
  ];
}
