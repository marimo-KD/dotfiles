{pkgs, ...}:
pkgs.stdenv.mkDerivation {
  name = "emacs-init-el";
  src = ./init.org;
  buildInputs = [pkgs.emacs];
  buildPhase = ''
    emacs -Q --batch --eval \
      "(progn
         (setq debug-on-error t)
         (setq vc-handled-backends nil)
         (require 'ob-tangle)
         (org-babel-tangle-file \"./init.org\"))";
  '';
  installPhase = ''
    mkdir -p $out/share/emacs
    cp ./init.el $out/share/emacs/
    cp ./early-init.el $out/share/emacs/
  '';
}
