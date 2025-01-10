{pkgs, ...}: {
  home = rec {
    username = "marimo";
    homeDirectory = "/Users/${username}";
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;
  services.syncthing.enable = true;
  imports = [
    ./programs/alacritty
    ./programs/bash
    ./programs/bat
    ./programs/carapace
    ./programs/direnv
    ./programs/discord
    ./programs/emacs
    ./programs/fd
    ./programs/firefox
    ./programs/fzf
    ./programs/git
    ./programs/gpg
    ./programs/latex
    ./programs/neovim
    ./programs/nushell
    ./programs/ripgrep
    ./programs/starship
    ./programs/zoxide

    ./packages.nix
  ];
  home.packages = with pkgs; [
    iterm2
  ];
}
