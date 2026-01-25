{pkgs, config, secrets, ...}: {
  virtualisation.quadlet = let
    inherit (config.virtualisation.quadlet) networks volumes builds;
    couchdb-config = (pkgs.formats.ini {}).generate "couchdb-config" {
      couchdb = {
        single_node = true;
        max_document_size = 50000000;
      };
      chttpd = {
        require_valid_user = true;
        max_http_request_size = 4294967296;
      };
      chttpd_auth = {
        require_valid_user = true;
        authentication_redirect = "/_utils/session.html";
      };
      httpd = {
        WWW-Authenticate = "Basic realm=\"couchdb\"";
        enable_cors = true;
      };
      cors = {
        origins = "app://obsidian.md,capacitor://localhost,http://localhost";
        credentials = true;
        headers = "accept, authorization, content-type, origin, referer";
        methods = "GET, PUT, POST, HEAD, DELETE";
        max_age = 3600;
      };
    };
    couchdb-containerfile = pkgs.writeText "Containerfile" ''
      FROM docker.io/library/couchdb:3
      RUN cat <<-EOF > /opt/couchdb/etc/local.ini
      ${couchdb-config.text}
      EOF
    '';
  in {
    volumes = {
      couchdb-datastore.volumeConfig = { };
      couchdb-locald.volumeConfig = { };
    };
    builds.couchdb.buildConfig = {
      file = couchdb-containerfile.outPath;
      workdir = "/";
    };
    containers.couchdb.containerConfig = {
      image = builds.couchdb.ref;
      networks = [ networks.internal.ref ];
      environments = {
        "COUCHDB_USER" = secrets.couchdb.user;
        "COUCHDB_PASSWORD" = secrets.couchdb.password;
      };
      volumes = [
        "${volumes.couchdb-datastore.ref}:/opt/couchdb/data"
        "${volumes.couchdb-locald.ref}:/opt/couchdb/etc/local.d"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.couchdb.rule" = "Host(`couchdb.vpn.aegagropila.org`)";
        "traefik.http.routers.couchdb.entrypoints" = "websecure";
        "traefik.http.services.couchdb.loadbalancer.server.port" = "5984";
      };
    };
  };
}
