{pkgs, ...}:{
  imports = [];
  users.users.marimo = {
    home = "/Users/marimo";
    shell = pkgs.zsh;
  };
  system.stateVersion = 5;
  ids.gids.nixbld = 30000;
  networking = {
    hostName = "malus";
    computerName = "malus";
    knownNetworkServices = [
      "Wi-Fi"
      "USB 10/100/1000 LAN"
      "Thunderbolt Bridge"
    ];
  };

  documentation.enable = false;

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

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
    nerd-fonts.iosevka
    nerd-fonts.symbols-only
  ];
}
