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
    # ./programs/discord
    # ./programs/emacs
    # ./programs/faust
    ./programs/fd
    # ./programs/firefox
    ./programs/fzf
    ./programs/git
    ./programs/gpg
    ./programs/helix
    ./programs/latex
    ./programs/neovim
    # ./programs/nushell
    # ./programs/puredata
    ./programs/ripgrep
    ./programs/starship
    ./programs/zoxide
    ./programs/zsh

    # ./packages.nix
  ];
  home.packages = with pkgs; [
    nixd
    typst
    gnuplot
    slack
    lean4
    (prismlauncher.override {
      jdks = [
        graalvm-ce
        zulu8
        zulu17
        zulu
      ];
    })
  ];
}
