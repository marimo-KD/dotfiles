{
  home = rec {
    username = "marimo";
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";
  };
  programs.home-manager.enable = true;
  imports = [
    ./apps.nix
    ./browser.nix
    ./desktop.nix
    ./dev.nix
    ./neovim.nix
  ];
}
