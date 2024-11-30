{pkgs, ...}: {
  imports = [
    ./nu
    ./bash
  ];
  programs = {
    carapace.enable = true;
    starship = {
      enable = true;
      settings.add_newline = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      delta = {
        enable = true;
      };
      ignores = [
        ".envrc"
        "shell.nix"
        ".dir-locals.el"
        ".dir-locals-2.el"
        ".direnv"
      ];
      extraConfig = {
        ghq.root = "~/src";
      };
    };
    lazygit.enable = true;
  };
  home.packages = with pkgs; [
    ghq
  ];
}
