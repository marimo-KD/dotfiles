{pkgs, ...}: {
  home = rec {
    username = "marimo";
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
    sessionVariables = {
      WINEFSYNC = 1;
    };
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-skk
      fcitx5-gtk
    ];
  };
  programs.home-manager.enable = true;
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
