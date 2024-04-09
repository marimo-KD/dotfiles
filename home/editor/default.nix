{pkgs,...}:{
  imports = [
    ./neovim
    ./emacs
  ];
  home.packages = with pkgs; [
    kakoune
    helix
  ];
}
