{pkgs, ...}: {
  home = rec {
    username = "marimo";
    homeDirectory = "/home/${username}";
    stateVersion = "23.11";
  };
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-skk
      fcitx5-gtk
    ];
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
