{ ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableLsColors = true;
    autocd = true;
    autosuggestion.enable = true;
    defaultKeymap = "emacs";
    syntaxHighlighting.enable = true;
    history.size = 10000;
  };
}
