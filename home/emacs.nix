{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = pkgs.emacs29-pgtk;
  };
  services.emacs = {
    package = pkgs.emacs29-pgtk;
  };
}
