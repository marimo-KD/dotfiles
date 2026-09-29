{
  config,
  ...
}:
{
  virtualisation.quadlet =
    let
      inherit (config.virtualisation.quadlet) networks volumes builds;
    in
    {
      volumes = {
        silverbullet-data.volumeConfig = {};
      };
      containers.silverbullet.containerConfig = {
        image = "ghcr.io/silverbulletmd/silverbullet:latest";
        autoUpdate = "registry";
        networks = [ "podman" ];
        volumes = [
          "${volumes.silverbullet-data.ref}:/data"
        ];
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.silverbullet.rule" = "Host(`sb.vpn.aegagropila.org`)";
          "traefik.http.routers.silverbullet.entrypoints" = "websecure";
          "traefik.http.services.silverbullet.loadbalancer.server.port" = "3000";
        };
      };
    };
}
