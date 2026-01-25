{ pkgs, ... }:
let
  faust2puredata = pkgs.faust.wrapWithBuildEnv {
    baseName = "faust2puredata";
    propagatedBuildInputs = with pkgs; [
      puredata
    ];
  };
in
{
  home.packages = with pkgs; [
    faust
    faust2puredata
  ];
}
