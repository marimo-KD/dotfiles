{config, pkgs, ...}:
let
  emanote = import (builtins.fetchTarball {
    url = "https://github.com/srid/emanote/archive/master.tar.gz";
    sha256 = "2ab29038da39c17c9ddd9bf0694585be72f36694c4ef1211f6bf4588dd515423";
  });
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
