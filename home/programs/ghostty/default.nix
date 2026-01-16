{pkgs, ...}: {
  programs.ghostty = {
    enable = true;
    package =
      if pkgs.stdenv.isLinux then
        pkgs.ghostty
      else if pkgs.stdenv.isDarwin then
        pkgs.ghostty-bin
      else
        throw "unsupported system";

    enableZshIntegration = true;
    installBatSyntax = true;
    systemd.enable = if pkgs.stdenv.isLinux then true else false;
    settings = {
      
    };
  };
}
