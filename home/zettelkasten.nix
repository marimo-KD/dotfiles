{config, pkgs, ...}:
let
  emanote = import (builtins.fetchTarball "https://github.com/srid/emanote/archive/master.tar.gz");
in {
  imports = [ emanote.homeManagerModule ];
  services.emanote = {
    enable = true;
    # host = "127.0.0.1"; # default listen address is 127.0.0.1
    # port = 7000;        # default http port is 7000
    notes = [
      "/home/marimo/ZettelKasten" 
    ];
    package = emanote.packages.${builtins.currentSystem}.default;
  };
  home.packages = with pkgs; [
    marksman
    zk
  ];
}
