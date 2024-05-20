{pkgs, ...} : 
{
  home.packages = with pkgs; [
    vital
    sfizz
    #reaper
    zrythm
  ];
}
