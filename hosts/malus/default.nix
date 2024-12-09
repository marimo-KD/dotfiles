{pkgs, ...}:{
  imports = [];
  users.users.marimo = {
    home = "/Users/marimo";
    shell = pkgs.zsh;
  };
  system.stateVersion = 5;
  networking = {
    hostName = "malus";
    computerName = "malus";
  };

  documentation.enable = false;

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  services.nix-daemon.enable = true; # multi-user install
  nix.settings = {
    trusted-users = ["marimo"];
    experimental-features = "nix-command flakes";
  };

  services.tailscale = {
    enable = true;
    overrideLocalDns = true;
  };

  fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      source-han-mono
      udev-gothic
      udev-gothic-nf
      ibm-plex
      (nerdfonts.override { fonts = [ "Iosevka" "NerdFontsSymbolsOnly"]; })
  ];
}
