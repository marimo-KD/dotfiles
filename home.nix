{
  home = rec {
    username = "marimo";
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";
  };
  programs.home-manager.enable = true;
  imports = [
    ./home/apps.nix
    ./home/browser.nix
    ./home/cli.nix
    ./home/desktop.nix
    ./home/dev.nix
    ./home/neovim.nix
  ];
}
