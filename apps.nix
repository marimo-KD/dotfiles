{pkgs, ...} : {
  programs.obs-studio = {
    enable = true;
  };
  home.packages = with pkgs; [
    neovide
    discord
    slack
    obsidian
  ];
}
