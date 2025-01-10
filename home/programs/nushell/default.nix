{ pkgs, ... }:
{
  programs = {
    nushell = {
      enable = true;
      configFile.source = ./config.nu;
    };
    carapace.enableNushellIntegration = true;
    starship.enableNushellIntegration = false;
    zoxide.enableNushellIntegration = true;
  };
}
