{config, pkgs, ...} : 
{
  programs = {
    password-store.enable = true;
    gpg = {
      enable = true;
    };
    ncmpcpp.enable = true;
  };
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "curses";
  };
  services.mpd = {
    enable = true;
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "Pipewire Output"
      }
    '';
    musicDirectory = /home/marimo/Music;
  };
  home.packages = with pkgs; [
    bat
    cmigemo
    fd
    # nb
    zk
    fzf
    gnuplot
    helix
    kakoune
    ripgrep
  ];
}
