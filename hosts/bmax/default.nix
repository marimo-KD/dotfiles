# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let hostconfig = config;
  prometheusAddress = "192.168.100.11";
  prometheusPort = 9090;
  grafanaAddress = "192.168.100.12";
  grafanaPort = 3000;
  couchdbAddress = "192.168.100.13";
  couchdbPort = 5984;
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

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
  ];

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" "containers0"]; # allow connections come from tailscale network.
  };

  services.tailscale = {
    enable = true;
    openFirewall = true; # Open a UDP Port that tailscale uses.
    useRoutingFeatures = "both";
  };

  services.netdata = {
    enable = true;
    package = pkgs.netdataCloud;
  };

  services.prometheus.exporters.node = {
    enable = true;
    port = 9000;
    enabledCollectors = ["systemd"];
    listenAddress = "192.168.100.1";
  };

  security.polkit.enable = true;

  networking = {
    bridges.containers0.interfaces = [];
    useDHCP = false;
    interfaces."enp2s0".useDHCP = true;
    interfaces."containers0".ipv4.addresses = [{
      address = "192.168.100.1";
      prefixLength = 24;
    }];
  };

  containers = {
    prometheus = {
      autoStart = true;
      privateUsers = "pick";
      privateNetwork = true;
      hostBridge = "containers0";
      localAddress = "${prometheusAddress}/24";
      config = { config, pkgs, lib, ...}: {
        system.stateVersion = "25.05";
        services.prometheus = {
          enable = true;
          globalConfig.scrape_interval = "20s";
          retentionTime = "14d";
          listenAddress = prometheusAddress;
          port = prometheusPort;
          scrapeConfigs = [
            {
              job_name = "node";
              static_configs = [{
                targets = ["192.168.100.1:${toString hostconfig.services.prometheus.exporters.node.port}"];
              }];
            }
          ];
        };
        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ config.services.prometheus.port ];
          };
          useHostResolvConf = lib.mkForce false;
        };
        services.resolved.enable = true;
      };
    };
    grafana = {
      autoStart = true;
      privateUsers = "pick";
      privateNetwork = true;
      hostBridge = "containers0";
      localAddress = "${grafanaAddress}/24";
      config = { config, pkgs, lib, ...}: {
        system.stateVersion = "25.05";
        services.grafana = {
          enable = true;
          settings = {
            server = {
              http_addr = grafanaAddress;
              http_port = grafanaPort;
              enable_gzip = true;
            };
          };
          openFirewall = true;      
        };
        networking = {
          firewall = {
            enable = true;
          };
          useHostResolvConf = lib.mkForce false;
        };
        services.resolved.enable = true;
      };
    };
    couchdb = {
      autoStart = true;
      privateUsers = "pick";
      privateNetwork = true;
      hostBridge = "containers0";
      localAddress = "${couchdbAddress}/24";
      config = { config, pkgs, lib, ...}: {
        system.stateVersion = "25.05";
        services.couchdb = {
          enable = true;
          bindAddress = couchdbAddress;
          port = couchdbPort;
        };
        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [ config.services.coucbdb.port ];
          };
          useHostResolvConf = lib.mkForce false;
        };
        services.resolved.enable = true;
      };
    };
  };
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

