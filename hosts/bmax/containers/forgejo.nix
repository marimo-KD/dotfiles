{
  pkgs,
  config,
  secrets,
  ...
}:
{
  virtualisation.quadlet =
    let
      inherit (config.virtualisation.quadlet) networks volumes builds;

    in
    {
      volumes = {
        forgejo-data.volumeConfig = {};
      };
      containers.forgejo.containerConfig = {
        image = "codeberg.org/forgejo/forgejo:15-rootless";
        networks = [ networks.internal.ref ];
        environments = {
        };
        volumes = [
        ];
        labels = {
        };
      };
    };
}
