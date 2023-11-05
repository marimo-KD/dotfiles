{
  home = rec {
    username = "marimo";
    homeDirectory = "/home/${username}";
    stateVersion = "23.05";
  };
  programs.home-manager.enable = true;
  imports = [
    ./neovim.nix
    ./browser.nix
    ./desktop.nix
    ./apps.nix
  ];
}
