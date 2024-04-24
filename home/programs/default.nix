{pkgs, ...}: 
{
  imports = [
    ./development
    ./gui
    ./cli
    ./typeset.nix
  ];
}
