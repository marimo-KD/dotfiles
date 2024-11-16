{pkgs, ...}: {
  programs = {
    firefox = {
      enable = true;
      package = (if pkgs.stdenv.isDarwin then pkgs.firefox-bin else pkgs.firefox);
    };
    obs-studio = {
      enable = pkgs.stdenv.isLinux;
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-backgroundremoval
      ];
    };
  };
  home.packages = with pkgs; [
    discord
    # use an alternative client because
    # the official client has no wayland screen sharing support.
    # vesktop
    slack
  ] ++ (if pkgs.stdenv.isLinux then [pkgs.zotero] else []);
  # discord
  home.file.".config/discord/settings.json".text = ''
    {
      "SKIP_HOST_UPDATE": true
    }
  '';
}
