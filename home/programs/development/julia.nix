{pkgs,...}: {
  home.packages = with pkgs; [
    julia-bin
  ];
}
