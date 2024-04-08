{...}: {
  home.packages = pkgs.alacritty;
  home.file.".config/alacritty" = {
    source = ./alacritty;
    recursive = true;
  };
}
