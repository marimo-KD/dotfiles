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
    zoxide.enable = true;
  };
}
