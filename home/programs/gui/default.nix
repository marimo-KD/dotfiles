{pkgs, ...}: {
  programs = {
    obs-studio.enable = true;
    firefox.enable = (if pkgs.stdenv.isDarwin then false else true);
  };
  home.packages = with pkgs; [
    discord
    slack
  ];
  # discord
  home.file.".config/discord/settings.json".text = ''
    {
      "SKIP_HOST_UPDATE": true
    }
  '';
}
