{pkgs, ...}: {
  home.packages = with pkgs; [
    clang
    deno
    # gcc
    nodejs-slim
    rust-bin.stable.latest.default
  ];
}
