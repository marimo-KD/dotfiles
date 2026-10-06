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
      containers.zotero-translator.containerConfig = {
        image = "docker.io/zotero/translation-server:latest";
        autoUpdate = "registry";
        networks = [ "podman" ];
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.zotero-translator.rule" = "Host(`zt.vpn.aegagropila.org`)";
          "traefik.http.routers.zotero-translator.entrypoints" = "websecure";
          "traefik.http.services.zotero-translator.loadbalancer.server.port" = "1969";
        };
      };
    };
}
