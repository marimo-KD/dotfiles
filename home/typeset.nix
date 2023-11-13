{config, pkgs, ...} : 
let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-basic
    collection-langjapanese
    collection-mathscience
    collection-luatex;
  });
in
{
  home.packages = with pkgs; [
    tex
    texlab
    typst
  ];
}
