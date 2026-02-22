{ pkgs, inputs, ... }:
{
  home = rec {
    username = "marimo";
    homeDirectory = "/Users/${username}";
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;
  imports = [
    ./programs/ghostty
    ./programs/bash
    ./programs/bat
    ./programs/carapace
    ./programs/direnv
    ./programs/fd
    ./programs/fzf
    ./programs/git
    ./programs/gpg
    ./programs/helix
    ./programs/latex
    ./programs/ripgrep
    ./programs/starship
    ./programs/zoxide
    ./programs/zsh
  ];
  home.packages = with pkgs; [
    inputs.neovim.packages.${pkgs.stdenv.system}.default
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
