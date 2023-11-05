{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraPackages = with pkgs; [
      rust-analyzer
    ];
  };
  home.packages = with pkgs; [
    bat
    ripgrep
  ];
  home.file.".config/nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
