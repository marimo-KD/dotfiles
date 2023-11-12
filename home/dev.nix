{pkgs, ...}: {
  home.packages = with pkgs; [
    gcc
    deno
    nodejs-slim
    rust-bin.stable.latest.default
  ];
}
