{pkgs, ... }: {
  programs.bash = {
    enable = true;
    initExtra = "exec nu";
  };
  home.packages = with pkgs; [
    nodePackages_latest.bash-language-server
  ];
}
