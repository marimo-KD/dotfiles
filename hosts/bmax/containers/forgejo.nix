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
        autoUpdate = "registry";
        networks = [ "podman" ];
        environments = {
          "FORGEJO__database__DB_TYPE" = "sqlite3";
        };
        volumes = [
          "${volumes.forgejo-data.ref}:/var/lib/gitea"
          "/etc/localtime:/etc/localtime:ro"
        ];
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.forgejo.rule" = "Host(`forgejo.vpn.aegagropila.org`)";
          "traefik.http.routers.forgejo.entrypoints" = "websecure";
          "traefik.http.services.forgejo.loadbalancer.server.port" = "3000";
        };
      };
    };
}
