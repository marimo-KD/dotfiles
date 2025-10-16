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
      ".DS_Store"
    ];
    extraConfig = {
      ghq.root = "~/src";
      diff.algorithm = "histogram";
    };
  };
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
  home.packages = with pkgs; [
    ghq
  ];
}
