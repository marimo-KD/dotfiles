{pkgs, ...}: {
  home.packages = with pkgs; [
    gnumake
    clang
    clang-tools
    deno
    # gcc
    nodejs-slim
    rust-bin.stable.latest.default
    rust-analyzer
  ];
}
