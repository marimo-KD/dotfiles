{pkgs,...}:{
  imports = [
    ./neovim
    ./emacs
  ];
  home.packages = with pkgs; [
    lapce
    neovide
    kakoune
    helix
  ];
}
