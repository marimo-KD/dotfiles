{ pkgs, inputs, ... }:
{
  home = rec {
    username = "marimo";
    homeDirectory = "/Users/${username}";
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;
  imports = [
    # ./programs/alacritty
    ./programs/ghostty
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
    tdf
    gnuplot
    lean4
    (prismlauncher.override {
      jdks = [
        graalvmPackages.graalvm-ce
        zulu8
        zulu17
        zulu
      ];
    })
  ];
}
