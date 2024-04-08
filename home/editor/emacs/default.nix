{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };
  services.emacs = {
    enable = false;
    package = pkgs.emacs29-pgtk;
  };
  home.packages = with pkgs; [
    graphviz
    sqlite
  ];
}
