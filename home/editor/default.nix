{pkgs,...}:{
  imports = [
    ./neovim
    ./emacs
  ];
  home.packages = with pkgs; [
    tree-sitter
    kakoune
    helix
  ];
}
