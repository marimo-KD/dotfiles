{pkgs,...}:{
  imports = [
    ./neovim
    ./emacs
  ];
  home.packages = with pkgs; [
    tree-sitter.withPlugins (_: allGrammars)
    kakoune
    helix
  ];
}
