{...}: {
  imports = [
    ./nu
    ./bash
  ];
  programs = {
    carapace.enable = true;
    starship = {
      enable = true;
      settings.add_newline = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
