{...}: {
  home = rec {
    username = "marimo";
    homeDirectory = "/Users/${username}";
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;
  imports = [
    ../editor
    ../terminal
    ../programs
    ../shell
  ];
}
