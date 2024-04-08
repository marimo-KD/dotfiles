{...}:{
  imports = [];
  users.users.marimo = {
    home = "/Users/marimo";
  };
  networking = {
    hostname = "monix";
  };

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  services.nix-darwin.enable = true;
  # services.nix-daemon.enable = true; # multi-user install
  nix.settings.trusted-users = ["marimo"];

  services.tailscale.enable = true;

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      source-han-sans
      source-han-serif
      source-han-mono
      sarasa-gothic
      iosevka
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
    ];
  };
}
