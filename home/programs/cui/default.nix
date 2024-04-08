{pkgs, ...}: {
  programs = {
    yazi.enable = true;
    gpg.enable = true;
    password-store.enable = true;
  };
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "curses";
  };
  home.packages = with pkgs; [
    bat
    fd
    fzf
    ripgrep
  ];
}
