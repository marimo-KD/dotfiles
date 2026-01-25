{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    withPython3 = false;
    viAlias = true;
    vimAlias = true;
  };
  home.file.".config/nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
