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
  ];
  home.file.".config/latexmk/latexmkrc".text = ''
#!/usr/bin/env perl
$latex = 'uplatex %O -kanji=utf8 -no-guess-input-enc -synctex=1 -interaction=nonstopmode %P';
$bibtex = 'upbibtex %O %B';
$biber = 'biber %O --bblencoding=utf8 -u -U --output_safechars %B';

$dvipdf = 'dvipdfmx %O -o %D %S';
$max_repeat = 5;

$pdf_mode = 3;
  '';
}
