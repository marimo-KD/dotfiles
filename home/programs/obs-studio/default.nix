{ pkgs, ... }:
{
  programs = {
    obs-studio = {
      enable = pkgs.stdenv.isLinux;
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-backgroundremoval
      ];
    };
  };
}
