{ config, ...}: {
  virtualisation.quadlet =
    let 
      inherit (config.virtualisation.quadlet) volumes;
    in {
      volumes = {
        fast-note-sync-storage.volumeConfig = {};
      };
      containers.fast-note-sync.containerConfig = {
        image = "docker.io/haierkeys/fast-note-sync-service:3.6.0";
        networks = [ "podman" ];
        volumes = [
          "${volumes.fast-note-sync-storage.ref}:/fast-note-sync/storage"
        ];
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.fast-note-sync.rule" = "Host(`fns.vpn.aegagropila.org`)";
          "traefik.http.routers.fast-note-sync.entrypoints" = "websecure";
          "traefik.http.services.fast-note-sync.loadbalancer.server.port" = "9000";
        };
      };
    };
}
