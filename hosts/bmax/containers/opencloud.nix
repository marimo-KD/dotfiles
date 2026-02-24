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
        opencloud-config.volumeConfig = {};
        opencloud-data.volumeConfig = {};
      };
      containers.opencloud.containerConfig = {
        image = "docker.io/opencloudeu/opencloud-rolling:5.1.0";
        entrypoint = "/bin/sh";
        exec = [ "-c" "opencloud init || true; opencloud server" ];
        networks = [ networks.internal.ref ];
        publishPorts = [
          "9200:9200"
        ];
        environments = {
          "PROXY_TLS" = "false";
          "PROXY_HTTP_ADDR" = "0.0.0.0:9200";
          "PROXY_ENABLE_BASIC_AUTH" = "true";
          "OC_URL" = "https://cloud.vpn.aegagropila.org";
          "OC_INSECURE" = "true";

          "OC_LOG_LEVEL" = "info";

          "IDM_ADMIN_PASSWORD" = secrets.opencloud.password;

          "STORAGE_USERS_DRIVER" = "posix";
          "STORAGE_USERS_ID_CACHE_STORE" = "nats-js-kv";
        };
        volumes = [
          "${volumes.opencloud-config.ref}:/etc/opencloud"
          "${volumes.opencloud-data.ref}:/var/lib/opencloud"
        ];
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.opencloud.rule" = "Host(`cloud.vpn.aegagropila.org`)";
          "traefik.http.routers.opencloud.entrypoints" = "websecure";
          "traefik.http.services.opencloud.loadbalancer.server.port" = "9200";
        };
      };
    };
}
