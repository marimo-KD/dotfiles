{config, pkgs, ...} : 
{
  programs = {
    password-store.enable = true;
    gpg = {
      enable = true;
    };
  };
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "curses";
  };
  home.packages = with pkgs; [
    cmigemo
    kakoune
    helix
  ];
}
