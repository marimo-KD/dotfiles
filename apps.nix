{pkgs, ...} : {
  programs.obs-studio = {
    enable = true;
  };
  home.packages = with pkgs; [
    discord
    slack
  ];
}
