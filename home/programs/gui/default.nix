{pkgs, ...}: {
  programs = {
    firefox = {
      enable = true;
      package = (if pkgs.stdenv.isDarwin then pkgs.firefox-bin else pkgs.firefox);
    };
    obs-studio.enable = pkgs.stdenv.isLinux;
  };
  home.packages = with pkgs; [
    discord
    slack
  ] ++ (if pkgs.stdenv.isLinux then [pkgs.zotero] else []);
  # discord
  home.file.".config/discord/settings.json".text = ''
    {
      "SKIP_HOST_UPDATE": true
    }
  '';
}
