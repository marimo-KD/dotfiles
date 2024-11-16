{pkgs, ...} :
{
  home.packages = with pkgs; [
    surge-XT # synthesizer
    vital # synthesizer
    sfizz # sampler(SFZ)
    decent-sampler # sampler
    guitarix # guitar amplifier simulator
    reaper # daw
    yabridge
    yabridgectl
    wineWowPackages.staging
    #zrythm
  ];
}
