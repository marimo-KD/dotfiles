{pkgs, config,...}: {
  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.clipboard-indicator }
      { package = pkgs.gnomeExtensions.vitals }
    ];
  };
}
