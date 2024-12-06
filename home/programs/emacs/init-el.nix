{lib, pkgs, emacs, ...}:
pkgs.stdenv.mkDerivation rec {
  name = "emacs-init-el";
  src = lib.cleanSource ./.;
  buildInputs = [emacs];
  substituted-init-org = pkgs.substituteAll {
    src = ./init.org;
    cmigemo = pkgs.cmigemo;
  };
  buildPhase = ''
    cp ${substituted-init-org} ./init-sub.org
    emacs -Q --batch --eval \
      "(progn
         (setq debug-on-error t)
         (setq vc-handled-backends nil)
         (require 'ob-tangle)
         (org-babel-tangle-file \"./init-sub.org\"))";
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
