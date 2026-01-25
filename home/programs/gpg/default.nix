{ pkgs, lib, ... }:
lib.mkMerge [
  {
    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = pkgs.stdenv.isLinux;
      pinentry.package = pkgs.pinentry-tty;
    };
  }

  (lib.mkIf pkgs.stdenv.isDarwin {
    home.file.".gnupg/gpg-agent.conf".text = ''
      pinentry-program ${pkgs.pinentry_mac}/Applications/pinentry-mac.app/Contents/MacOS/pinentry-mac
    '';
    home.packages = [
      pkgs.gnupg
      pkgs.pinentry_mac
    ];
  })

]
