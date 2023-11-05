{pkgs, ...}: {
  home.packages = with pkgs: {
    gcc
    deno
    nodejs-slim
  };
}
