{...}: {
  programs = {
    nushell = {
      enable = true;
      configFile.text = ''
      $env.config = {
        show_banner: false
      }
      # zellij
      def start_zellij [] {
        if 'ZELLIJ' not-in ($env | columns) {
          if 'ZELLIJ_AUTO_ATTACH' in ($env | columns) and $env.ZELLIJ_AUTO_ATTACH == 'true' {
            zellij attach -c
          } else {
            zellij
          }
        }
      }

      # start_zellij

      def --env ya [...args] {
        let tmp = (mktemp -t "yazi-cwd.XXXXX")
        yazi ...$args --cwd-file $tmp
        let cwd = (open $tmp)
        if $cwd != "" and $cwd != $env.PWD {
          cd $cwd
        }
        rm -fp $tmp
      }
      '';
      envFile.text = "
      $env.PASSWORD_STORE_DIR = ''
      $env.ZELLIJ_AUTO_ATTACH = 'true'
      ";
    };
    carapace.enableNushellIntegration = true;
    starship.enableNushellIntegration = true;
    zoxide.enableNushellIntegration = true;
  };
  home.file.".config/nushell/emacs-config.nu".text = ''
    source ~/.config/nushell/config.nu
    source ~/.config/nushell/vterm.nu                        
  '';
  home.file.".config/nushell/vterm.nu".source = ./vterm.nu;
}
