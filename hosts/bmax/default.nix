# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, config, lib, pkgs, secrets, ... }:
let hostconfig = config;
  hostAddress = "192.168.100.1";
  dnsAddress = "192.168.100.100";
  nginxAddress = "192.168.100.101";
  nginxExporterPort = 9113;
  prometheusAddress = "192.168.100.11";
  prometheusPort = 9090;
  blackboxAddress = "192.168.100.31";
  blackboxPort = 9115;
  grafanaAddress = "192.168.100.12";
  grafanaPort = 3000;
  silverbulletAddress = "192.168.100.14";
  silverbulletPort = 7000;
  couchdbAddress = "192.168.100.41";
  couchdbPort = 5984;
  storageAddress = "192.168.100.40";
  postgresqlPort = 5432;
  postgresqlExporterPort = 9115;
  rustfsConsolePort = 9001;
  rustfsPort = 9000;
  minifluxAddress = "192.168.100.15";
  minifluxPort = 8080;
  webdavAddress = "192.168.100.16";
  webdavPort = 6065;
  container-extraHosts = ''
    ${hostAddress} host
    ${dnsAddress} dns.containers
    ${nginxAddress} nginx.containers
    ${prometheusAddress} prometheus.containers
    ${blackboxAddress} blackbox-exporter.containers
    ${grafanaAddress} grafana.containers
    ${silverbulletAddress} silverbullet.containers
    ${couchdbAddress} couchdb.containers
    ${storageAddress} postgresql.containers
    ${storageAddress} rustfs.containers
    ${storageAddress} storage.containers
    ${minifluxAddress} miniflux.containers
    ${webdavAddress} webdav.containers
  '';
  in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "bmax"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.marimo = {
    isNormalUser = true;
    home = "/home/marimo";
    extraGroups = ["wheel"];
  };

  users.users.podman = {
    isSystemUser = true;
    home = "/var/lib/podman";
    createHome = true;
    group = "podman";
    uid = 993;
    linger = true;
    autoSubUidGidRange = true;
  };

  users.groups.podman = {};

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
  ];

  services.tailscale = {
    enable = true;
    openFirewall = true; # Open a UDP Port that tailscale uses.
    useRoutingFeatures = "both";
  };

  services.cloudflared = {
    enable = true;
    certificateFile = "/home/marimo/.cloudflared/cert.pem";
    tunnels.bmax0 = {
      default = "http_status:404";
      credentialsFile = "/home/marimo/.cloudflared/3cbf78f1-2bb7-482d-99ea-e7dd3994d0c9.json";
    };
  };

  services.traefik = {
    enable = true;
    dataDir = "/var/lib/traefik";
    environmentFiles = [ "/home/marimo/.acme-credentials/env" ];
    group = "podman";
    staticConfigOptions = {
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
        http.tls.certResolver = "letsencrypt";
      };
      certificationResolvers.letsencrypt.acme = {
        email = secrets.acme.email;
        storage = "${config.services.traefik.dataDir}/acme.json";
        caServer = "https://acme-staging-v02.api.letsencrypt.org/directory";
        dnsChallenge = {
          provider = "cloudflare";
          resolvers = ["1.1.1.1:53" "8.8.8.8:53"];
        };
      };
      providers.docker = {
        endpoint = "unix://run/user/${toString config.users.users.podman.uid}/podman/podman.sock";
        exposedByDefault = false;
      };
      api.dashboard = true;
    };
  };

  services.prometheus.exporters.node = {
    enable = true;
    port = 9000;
    enabledCollectors = ["systemd"];
    listenAddress = hostAddress;
  };

  security.polkit.enable = true;

  networking = {
    bridges.containers0.interfaces = [];
    useDHCP = false;
    interfaces."enp2s0".useDHCP = true;
    interfaces."containers0".ipv4.addresses = [{
      address = hostAddress;
      prefixLength = 24;
    }];
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" "containers0"]; # allow connections come from tailscale network.
    };
    nat = {
      enable = true;
      internalInterfaces = [ "containers0" ];
      externalInterface = "enp2s0";
    };
  };

  virtualisation.quadlet.enable = true;

  home-manager.users.podman = {pkgs, config, ...}: {
    imports = [ inputs.quadlet-nix.homeManagerModules.quadlet ];
    home.stateVersion = "25.05";
    virtualisation.quadlet = let
      inherit (config.virtualisation.quadlet) networks pods volumes;
    in {
      
    };
  };

  # containers = {
  #   dns = {
  #     # dns server for name resolving in the tailnet.
  #     autoStart = true;
  #     privateUsers = "pick";
  #     privateNetwork = true;
  #     hostBridge = "containers0";
  #     localAddress = "${dnsAddress}/24";
  #     config = { config, pkgs, lib, ...}: {
  #       system.stateVersion = "25.05";
  #       services.dnsmasq = {
  #         enable = true;
  #         alwaysKeepRunning = true;
  #         resolveLocalQueries = true;
  #         settings = {
  #           address = "/.aegagropila.org/${nginxAddress}";
  #           server = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ]; # cloudflare dns
  #         };
  #       };
  #       networking = {
  #         firewall.enable = true;
  #         firewall.allowedTCPPorts = [ 53 ];
  #         firewall.allowedUDPPorts = [ 53 ];
  #         extraHosts = container-extraHosts;
  #         defaultGateway = hostAddress;
  #       };
  #     };
  #   };
  #   prometheus = {
  #     autoStart = true;
  #     privateUsers = "pick";
  #     privateNetwork = true;
  #     hostBridge = "containers0";
  #     localAddress = "${prometheusAddress}/24";
  #     config = { config, pkgs, lib, ...}: {
  #       system.stateVersion = "25.05";
  #       services.prometheus = {
  #         enable = true;
  #         globalConfig.scrape_interval = "20s";
  #         retentionTime = "14d";
  #         listenAddress = prometheusAddress;
  #         port = prometheusPort;
  #         scrapeConfigs = [
  #           {
  #             job_name = "node";
  #             static_configs = [{
  #               targets = ["${hostAddress}:${toString hostconfig.services.prometheus.exporters.node.port}"];
  #             }];
  #           }
  #           {
  #             job_name = "blackbox";
  #             metrics_path = "/probe";
  #             static_configs = [{
  #               targets = [
  #                 "prometheus.containers:${toString prometheusPort}"
  #                 "grafana.containers:${toString grafanaPort}"
  #                 "silverbullet.containers:${toString silverbulletPort}"
  #               ];
  #             }];
  #             relabel_configs = [
  #               {
  #                 source_labels = ["__address__"];
  #                 target_label = "__param_target";
  #               }
  #               {
  #                 source_labels = ["__param_target"];
  #                 target_label = "instance";
  #               }
  #               {
  #                 target_label = "__address__";
  #                 replacement = "blackbox-exporter.containers:9115";
  #               }
  #             ];
  #           }
  #           {
  #             job_name = "nginx";
  #             static_configs = [{
  #               targets = [
  #                 "nginx.containers:${toString nginxExporterPort}"
  #               ];
  #             }];
  #           }
  #           {
  #             job_name = "postgreSQL";
  #             static_configs = [{
  #               targets = [
  #                 "postgresql.containers:${toString postgresqlExporterPort}"
  #               ];
  #             }];
  #           }
  #         ];
  #       };
  #       networking = {
  #         firewall = {
  #           enable = true;
  #           allowedTCPPorts = [ config.services.prometheus.port ];
  #         };
  #         nameservers = [ dnsAddress ];
  #         defaultGateway = hostAddress;
  #       };
  #     };
  #   };
  #   blackbox-exporter = {
  #     autoStart = true;
  #     privateUsers = "pick";
  #     privateNetwork = true;
  #     hostBridge = "containers0";
  #     localAddress = "${blackboxAddress}/24";
  #     config = { config, pkgs, lib, ...}: {
  #       system.stateVersion = "25.05";
  #       services.prometheus.exporters.blackbox = {
  #         enable = true;
  #         port = blackboxPort;
  #         openFirewall = true;
  #         configFile = pkgs.writeText "config.yml"
  #           ''
  #             modules:
  #               http_2xx:
  #                 prober: http
  #                 http:
  #           '';
  #       };
  #       networking = {
  #         firewall.enable = true;
  #         nameservers = [ dnsAddress ];
  #         defaultGateway = hostAddress;
  #       };
  #     };
  #   };
  #   grafana = {
  #     autoStart = true;
  #     privateUsers = "pick";
  #     privateNetwork = true;
  #     hostBridge = "containers0";
  #     localAddress = "${grafanaAddress}/24";
  #     config = { config, pkgs, lib, ...}: {
  #       system.stateVersion = "25.05";
  #       services.grafana = {
  #         enable = true;
  #         settings = {
  #           server = {
  #             http_addr = grafanaAddress;
  #             http_port = grafanaPort;
  #             enable_gzip = true;
  #           };
  #         };
  #         openFirewall = true;      
  #       };
  #       networking = {
  #         firewall.enable = true;
  #         nameservers = [ dnsAddress ];
  #         defaultGateway = hostAddress;
  #       };
  #     };
  #   };
  #   postgresql = {
  #     autoStart = true;
  #     privateUsers = "pick";
  #     privateNetwork = true;
  #     hostBridge = "containers0";
  #     localAddress = "${storageAddress}/24";
  #     config = {config, pkgs, lib, ...}: {
  #       system.stateVersion = "25.05";
  #       services.postgresql = {
  #         enable = true;
  #         enableJIT = true;
  #         enableTCPIP = true;
  #         settings.port = postgresqlPort;
  #         ensureUsers =[
  #           {
  #             name = "miniflux";
  #             ensureDBOwnership = true;
  #           }
  #           {
  #             name = "exporter";
  #           }
  #         ];
  #         ensureDatabases = [ "miniflux" ];
  #         authentication = pkgs.lib.mkOverride 10 ''
  #           #type database DBuser origin-address auth-method
  #           local all      all     trust
  #           # ipv4
  #           host  all      all     ${hostAddress}/24   trust
  #         '';
  #       };
  #       services.prometheus.exporters.postgres = {
  #         enable = true;
  #         listenAddress = storageAddress;
  #         port = postgresqlExporterPort;
  #         environmentFile = pkgs.writeText "exporter.env" ''
  #           DATA_SOURCE_USER=exporter
  #           DATA_SOURCE_URI=localhost:${toString postgresqlPort}/main?sslmode=disable
  #         '';
  #       };
  #       # services.rustfs = {
  #       #   enable = true;
  #       #   port = rustfsPort;
  #       #   consolePort = rustfsConsolePort;
  #       #   rootCredentialsFile = null;
  #       #   openFirewall = true;
  #       # };
  #       networking = {
  #         firewall.enable = true;
  #         firewall.allowedTCPPorts = [ postgresqlPort postgresqlExporterPort ];
  #         nameservers = [ dnsAddress ];
  #         defaultGateway = hostAddress;
  #       };
  #     };
  #   };
  #   couchdb = {
  #     autoStart = true;
  #     privateUsers = "pick";
  #     privateNetwork = true;
  #     hostBridge = "containers0";
  #     localAddress = "${couchdbAddress}/24";
  #     config = {...}: {
  #       system.stateVersion = "25.05";
  #       services.couchdb = {
  #         enable = true;
  #         bindAddress = couchdbAddress;
  #         port = couchdbPort;
  #         adminPass = "admin";
  #         extraConfig = {
  #           couchdb = {
  #             single_node = true;
  #             max_document_size = 50000000;
  #           };
  #           chttpd = {
  #             require_valid_user = true;
  #             max_http_request_size = 4294967296;
  #             enable_cors = true;
  #           };
  #           chttpd_auth = {
  #             require_valid_user = true;
  #             authentication_redirect = "/_utils/session.html";
  #           };
  #           httpd = {
  #             WWW-Authenticate = "Basic realm=\"couchdb\"";
  #             enable_cors = true;
  #           };
  #           cors = {
  #             origins = "app://obsidian.md,capacitor://localhost,http://localhost";
  #             credentials = true;
  #             headers = "accept, authorization, content-type, origin, referer";
  #             methods = "GET, PUT, POST, HEAD, DELETE";
  #             max_age = 3600;
  #           };
  #         };
  #       };
  #       networking = {
  #         firewall.enable = true;
  #         firewall.allowedTCPPorts = [ couchdbPort ];
  #         nameservers = [ dnsAddress ];
  #         defaultGateway = hostAddress;
  #       };
  #     };
  #   };
  #   miniflux = {
  #     autoStart = true;
  #     privateUsers = "pick";
  #     privateNetwork = true;
  #     hostBridge = "containers0";
  #     localAddress = "${minifluxAddress}/24";
  #     bindMounts = {
  #       credentials = {
  #         mountPoint = "/mnt/miniflux:idmap";
  #         hostPath = "/home/marimo/.miniflux";
  #         isReadOnly = true;
  #       };
  #     };
  #     config = {config, pkgs, lib, ...}: {
  #       system.stateVersion = "25.05";
  #       services.miniflux = {
  #         enable = true;
  #         createDatabaseLocally = false;
  #         config = {
  #           LISTEN_ADDR = "${minifluxAddress}:${toString minifluxPort}";
  #           CREATE_ADMIN = 1;
  #           WATCHDOG = 1;
  #           BASE_URL = "https://miniflux.aegagropila.org";
  #           DATABASE_URL = "host=postgresql.containers port=${toString postgresqlPort} user=miniflux dbname=miniflux sslmode=disable";
  #         };
  #         adminCredentialsFile = "/mnt/miniflux/admin";
  #       };
  #       networking = {
  #         firewall.enable = true;
  #         firewall.allowedTCPPorts = [ minifluxPort ];
  #         nameservers = [ dnsAddress ];
  #         defaultGateway = hostAddress;
  #       };
  #     };
  #   };
  #   webdav = {
  #     autoStart = true;
  #     privateUsers = "pick";
  #     privateNetwork = true;
  #     hostBridge = "containers0";
  #     localAddress = "${webdavAddress}/24";
  #     bindMounts = {
  #       credentials = {
  #         mountPoint = "/mnt/webdav:idmap";
  #         hostPath = "/home/marimo/.webdav.env";
  #         isReadOnly = true;
  #       };
  #     };
  #     config = {config, pkgs, lib, ...}: {
  #       system.stateVersion = "25.05";
  #       services.webdav = {
  #         enable = true;
  #         environmentFile = /mnt/webdav;
  #         settings = {
  #           address = webdavAddress;
  #           port = webdavPort;
  #           prefix = "/";
  #           behindProxy = true;
  #           directory = "/data";
  #           permissions = "R";
  #           users = [
  #             {
  #               username = "{env}ZOTERO_USERNAME";
  #               password = "{env}ZOTERO_PASSWORD";
  #               rules = [
  #                 {
  #                   path = "/zotero/";
  #                   permissions = "CRUD";
  #                 }
  #               ];
  #             }
  #           ];
  #         };
  #       };
  #       networking = {
  #         firewall.enable = true;
  #         firewall.allowedTCPPorts = [ webdavPort ];
  #         nameservers = [ dnsAddress ];
  #         defaultGateway = hostAddress;
  #       };
  #     };
  #   };
  # };
  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  nixpkgs.config.allowUnfree = true;
}

