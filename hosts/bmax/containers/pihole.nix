{pkgs, config, secrets, ...}: {
  virtualisation.quadlet = let
    inherit (config.virtualisation.quadlet) networks volumes;
    
  in {
    volumes.pihole-etc.volumeConfig = {};
    containers.pihole.containerConfig = {
      image = "docker.io/pihole/pihole:2025.11.1";
      publishPorts = [ "53:53/tcp" "53:53/udp" ];
      networks = [ networks.internal.ref ];
      environments = {
        "TZ" = "Asia/Tokyo";
        "FTLCONF_webserver_api_password" = secrets.pihole.password;
        "FTLCONF_dns_upstreams" = "1.1.1.1;1.0.0.1";
        "FTLCONF_misc_dnsmasq_lines" = "address=/.aegagropila.org/100.106.235.8";
      };
      volumes = [
        "${volumes.pihole-etc.ref}:/etc/pihole"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.pihole.entrypoints" = "websecure";
        "traefik.http.routers.pihole.rule" = "Host(`pihole.aegagropila.org`)";
        "traefik.http.services.pihole.loadbalancer.server.port" = "80";
      };
    };
  };
}
