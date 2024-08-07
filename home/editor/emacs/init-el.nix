{pkgs, emacs, ...}:
pkgs.stdenv.mkDerivation {
  name = "emacs-init-el";
  src = ./.;
  buildInputs = [emacs];
  buildPhase = ''
    emacs -Q --batch --eval \
      "(progn
         (setq debug-on-error t)
         (setq vc-handled-backends nil)
         (require 'ob-tangle)
         (org-babel-tangle-file \"./init.org\"))";
    emacs -Q --batch -f batch-byte-compile init.el;
    emacs -Q --batch -f batch-byte-compile early-init.el;
  '';
  installPhase = ''
    mkdir -p $out/share/emacs
    cp ./init.el $out/share/emacs/
    cp ./early-init.el $out/share/emacs/
    cp ./init.elc $out/share/emacs/
    cp ./early-init.elc $out/share/emacs/
  '';
}
