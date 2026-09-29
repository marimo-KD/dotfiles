{ pkgs, config, ... }:
{
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
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKY4MD0f6uLSChlKFmYBxs1th1tHUYYci3+y8sYSTfVC";
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
