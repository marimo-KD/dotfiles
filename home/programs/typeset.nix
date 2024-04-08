{config, pkgs, ...} : 
let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
    collection-binextra
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
  home.file.".config/latexmk/latexmkrc".text = ''
#!/usr/bin/env perl
$latex = 'uplatex %O -synctex=1 -interaction=nonstopmode %P';
$bibtex = 'upbibtex';
$biber = 'biber';

$dvipdf = 'dvipdfmx %O -o %R.pdf %S';
$max_repeat = 5;

$pdf_mode = 3;
  '';
}
