{config, pkgs, ...} : 
let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
    collection-fontsrecommended
    collection-langjapanese
    collection-mathscience
    collection-latex
    collection-latexextra
    collection-latexrecommended
    collection-luatex
    collection-pictures
    mleftright;
  });
in
{
  home.packages = with pkgs; [
    tex
    texlab
    typst
  ];
}
