{ pkgs, ... }:
{
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
    clearDefaultKeybinds = true;
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
      macos-option-as-alt = false;

      keybinds = [
        "cmd+h=goto_split:left"
        "cmd+j=goto_split:down"
        "cmd+k=goto_split:up"
        "cmd+l=goto_split:right"

        "cmd+w>h=new_split:left"
        "cmd+w>j=new_split:down"
        "cmd+w>k=new_split:up"
        "cmd+w>l=new_split:right"

        "cmd+w>shift+h=resize_split:left,20"
        "cmd+w>shift+j=resize_split:down,20"
        "cmd+w>shift+k=resize_split:up,20"
        "cmd+w>shift+l=resize_split:right,20"

        "cmd+t=new_tab"

        "cmd+q=close_surface"
      ];
    };
  };
}
