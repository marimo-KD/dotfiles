{pkgs, ...}: {
  programs = {
    yazi.enable = true;
    gpg.enable = true;
    password-store.enable = true;
  };
  services.gpg-agent = {
    enable = (if pkgs.stdenv.isDarwin then false else true);
    pinentryPackage = pkgs.pinentry-tty;
  };
  home.packages = with pkgs; [
    bat
    fd
    fzf
    ripgrep
  ];
}
