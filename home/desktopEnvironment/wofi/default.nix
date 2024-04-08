{pkgs, ...}: {
  home.packages = with pkgs; [
    wofi
  ];
  home.files.".config/wofi" = {
    source = ./wofi;
    recursive = true;
  };
}
