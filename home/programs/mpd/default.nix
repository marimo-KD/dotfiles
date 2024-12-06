{config, pkgs, ...} :
{
  services.mpd = {
    enable = true;
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "Pipewire Output"
      }
    '';
    musicDirectory = "${config.home.homeDirectory}/Music";
  };
}
