{pkgs, ...}: {
  programs.emacs = {
    enable = true;
    package = (if pkgs.stdenv.isDarwin then pkgs.emacs-macport else pkgs.emacs29-pgtk);
  };
  home.packages = with pkgs; [
    graphviz
    sqlite
  ];
}
