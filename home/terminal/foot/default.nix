{...}: {
  home.packages = (if pkgs.stdenv.isLinux then [pkgs.foot] else []);
  home.file.".config/foot/foot.ini".source = ./foot.ini;
}
