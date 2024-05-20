{pkgs, ...}:{
  programs.emacs = {
    enable = true;
    package = (
      let myemacs = (
            if pkgs.stdenv.isDarwin
            then pkgs.emacs-macport
            else pkgs.emacs29-pgtk
          );
      in myemacs
    );
    extraPackages = (epkgs: [
      epkgs.vterm
      epkgs.pdf-tools
    ]);
  };
  home.file.".emacs.d/init.el".source = ./init.el;
  home.file.".emacs.d/early-init.el".source = ./early-init.el;
  home.packages = with pkgs; [
    emacs-lsp-booster
    graphviz
    sqlite
  ];
}
