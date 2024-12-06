{pkgs,...}: {
  programs.git = {
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
  home.packages = with pkgs; [
    ghq
  ];
}
