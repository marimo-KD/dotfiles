{pkgs, ...}:{
  imports = [];
  users.users.marimo = {
    home = "/Users/marimo";
    shell = pkgs.bashInteractive;
  };
  system.stateVersion = 5;
  networking = {
    hostName = "malus";
    computerName = "malus";
  };

  documentation.enable = false;

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  programs.bash.enable = true;
  environment.shells = [ pkgs.bashInteractive pkgs.zsh ];

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
      source-han-sans
      source-han-serif
      source-han-mono
      plemoljp
      plemoljp-nf
      ibm-plex
      (nerdfonts.override { fonts = [ "Iosevka" "NerdFontsSymbolsOnly"]; })
  ];
}
