{pkgs,...}: {
  home.packages = (if pkgs.stdenv.isDarwin then [] else [pkgs.julia-bin]);
}
