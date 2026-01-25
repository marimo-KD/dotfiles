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
      font-family = "PlemolJP Console NF";
      font-size = 14;
      font-thicken = true;
      alpha-blending = "linear-corrected";

      theme = "light:Gruvbox Light Hard,dark:Catppuccin Mocha";

      mouse-hide-while-typing = true;
      mouse-scroll-multiplier = 2;

      fullscreen = true;
      resize-overlay = "never";

      macos-titlebar-style = "tabs";
      macos-option-as-alt = true;
    };
  };
}
