{ pkgs }:
with pkgs;

stdenv.mkDerivation {
  pname = "Emacs portal";
  version = "git";

  src = fetchGit {
      name = "filechooser";
      url = "https://codeberg.org/rahguzar/filechooser";
      rev = "866304ab4244865108e12499f6e3be63e4981f92";
    };

  #installPhase = ''
  #  mkdir -p $out/share/dbus-1/services/;
  #  cp org.gnu.Emacs.FileChooser.service $out/share/dbus-1/services/;
  #  mkdir -p $out/share/xdg-desktop-portal/portals/;
  #  cp emacs.portal $out/share/xdg-desktop-portal/portals/;
  #  '';

  installPhase = ''
    mkdir -p $out/share/dbus-1/services/;
    cat <<END > $out/share/dbus-1/services/org.gnu.Emacs.FileChooser.service
    [D-BUS Service]
    Name=org.gnu.Emacs.FileChooser
    Exec=${pkgs.emacs29-pgtk}/bin/emacsclient -s server -e '(filechooser-start)'
    END
    mkdir -p $out/share/xdg-desktop-portal/portals/;
    cat <<END > $out/share/xdg-desktop-portal/portals/emacs.portal
    [portal]
    DBusName=org.gnu.Emacs.FileChooser
    Interfaces=org.freedesktop.impl.portal.FileChooser;
    UseIn=hyprland;wlroots;sway;
    END
  '';
}
