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

      keybind = [
        "super+c=copy_to_clipboard"
        "super+v=paste_from_clipboard"

        "super+h=goto_split:left"
        "super+j=goto_split:down"
        "super+k=goto_split:up"
        "super+l=goto_split:right"

        "super+w>h=new_split:left"
        "super+w>j=new_split:down"
        "super+w>k=new_split:up"
        "super+w>l=new_split:right"

        "super+w>shift+h=resize_split:left,20"
        "super+w>shift+j=resize_split:down,20"
        "super+w>shift+k=resize_split:up,20"
        "super+w>shift+l=resize_split:right,20"

        "super+t=new_tab"
        "super+1=goto_tab:1"
        "super+2=goto_tab:2"
        "super+3=goto_tab:3"
        "super+4=goto_tab:4"
        "super+5=goto_tab:5"
        "super+6=goto_tab:6"
        "super+7=goto_tab:7"
        "super+8=goto_tab:8"

        "super+q=close_surface"
      ];
    };
  };
}
