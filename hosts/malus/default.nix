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
    # enable = true;
    # overrideLocalDns = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    source-han-mono
    plemoljp-nf
    roboto # for reapertips
    fira # for reapertips
    nerd-fonts.symbols-only
  ];
}
