{pkgs, ...} : {
  programs.obs-studio = {
    enable = true;
  };
  home.packages = with pkgs; [
    simple-scan
    lapce
    neovide
    discord
    slack
    obsidian
  ];
  home.file.".config/discord/settings.json".text = ''
    {
      "SKIP_HOST_UPDATE": true
    }
  '';
}
