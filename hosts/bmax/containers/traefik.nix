{pkgs, config, secrets, ...}: {
  virtualisation.quadlet = let
    inherit (config.virtualisation.quadlet) networks;
    traefik-config = (pkgs.formats.yaml {}).generate "traefik-config" {
      entryPoints = {
        web = {
          address = ":80";
          asDefault = true;
          http.redirections.entrypoint = {
            to = "websecure";
            scheme = "https";
          };
        };
        websecure = {
          address = ":443";
          asDefault = true;
          http.tls = {
            certResolver = "letsencrypt";
          };
        };
      };
      certificatesResolvers.letsencrypt.acme = {
        email = secrets.acme.email;
        storage = "/etc/traefik/acme.json";
        # caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";
        caServer = "https://acme-v02.api.letsencrypt.org/directory";
        dnsChallenge = {
          provider = "cloudflare";
          resolvers = ["1.1.1.1:53" "8.8.8.8:53"];
        };
      };
      log = {
        level = "INFO";
        format = "common";
      };
      providers.docker = {
        exposedByDefault = false;
        watch = true;
      };
      api.dashboard = true;
    };
  in {
    containers.traefik.containerConfig = {
      image = "docker.io/library/traefik:v3.6.6";
      publishPorts = [ "80:80" "443:443" ];
      networks = [ networks.internal.ref ];
      environments = {
        "CF_DNS_API_TOKEN" = secrets.acme.cf-dns-api-token;
      };
      volumes = [
        "/run/user/${toString config.home.uid}/podman/podman.sock:/var/run/docker.sock:ro"
        "${traefik-config}:/etc/traefik/traefik.yml:ro"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.dashboard.service" = "api@internal";
        "traefik.http.routers.dashboard.rule" = "Host(`traefik.aegagropila.org`)";
        "traefik.http.routers.dashboard.entrypoints" = "websecure";
        "traefik.http.routers.dashboard.tls.certresolver" = "letsencrypt";
        "traefik.http.routers.dashboard.tls.domains[0].main" = "aegagropila.org";
        "traefik.http.routers.dashboard.tls.domains[0].sans" = "*.aegagropila.org";
      };
    };
  };
}
