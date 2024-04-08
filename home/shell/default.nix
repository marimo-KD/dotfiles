{...}: {
  imports = [
    ./nu
    ./bash
  ];
  programs = {
    starship = {
      enable = true;
      settings.add_newline = true;
    };
    zoxide.enable = true;
  };
}
