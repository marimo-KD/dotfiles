{pkgs, ...}: {
  services.emacs = {
    package = pkgs.emacs29;
    install = true;
  };
}
