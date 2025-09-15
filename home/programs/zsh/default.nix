{...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
    autosuggestion.enable = true;
    defaultKeymap = "emacs";
    syntaxHighlighting.enable = true;
    history.size = 10000;
  };
}
