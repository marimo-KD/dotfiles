{pkgs,...}: {
  home.packages = with pkgs; [
    nil
    nixfmt
    cachix
  ];
}
