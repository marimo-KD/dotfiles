{ pkgs,... }: {
  programs.codex = {
    enable = true;
  };
  home.packages = with pkgs; [
    codex-acp
  ];
}
