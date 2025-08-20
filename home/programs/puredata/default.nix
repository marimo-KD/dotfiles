{pkgs, ...}: {
  home.packages = with pkgs; [
    puredata
    plugdata
    faust
  ];
}
