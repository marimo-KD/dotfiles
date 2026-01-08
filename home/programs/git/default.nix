{pkgs, config, ...}: {
  programs.git = {
    enable = true;
    ignores = [
      ".envrc"
      "shell.nix"
      ".dir-locals.el"
      ".dir-locals-2.el"
      ".direnv"
      ".DS_Store"
    ];
    signing = {
      key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      format = "ssh";
    };
    settings = {
      user.name = "marimo-KD"; # Github Username
      user.email = "34938736+marimo-KD@users.noreply.github.com"; # Github noreply Email
      ghq.root = "~/src";
      diff.algorithm = "histogram";
    };
  };
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
  home.packages = with pkgs; [
    ghq
  ];
}
