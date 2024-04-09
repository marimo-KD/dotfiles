{pkgs,...}:{
  imports = [
    ./neovim
    ./emacs
  ];
  home.packages = with pkgs; [
    (tree-sitter.withPlugins (p: builtins.attrValues p))
    kakoune
    helix
  ];
}
