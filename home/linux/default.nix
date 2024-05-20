{...}: {
  home = rec {
    username = "marimo";
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;
  catppuccin.flavour = "frappe";
  imports = [
    ../editor
    ../desktopEnvironment
    ../shell
    ../terminal
    ../programs
    ../programs/mpd.nix
    ../programs/daw.nix
  ];
}
