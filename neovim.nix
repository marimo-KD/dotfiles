{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      ripgrep
      deno
      rust-analyzer
    ];
  };
  home.file.".config/nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
