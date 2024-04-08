{
  home = rec {
    username = "marimo";
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;
  imports = [
    ./home/cli.nix
    ./home/desktop.nix
    ./home/dev.nix
    ./home/emacs.nix
    ./home/mpd.nix
    ./home/neovim.nix
    ./home/typeset.nix
  ];
}
