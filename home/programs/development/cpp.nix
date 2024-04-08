{pkgs, ...}: {
  home.packages = with pkgs; [
    gnumake
    clang
    clang-tools
  ];
}
