# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

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
    trustedInterfaces = [ "tailscale0" ]; # allow connections come from tailscale network.
    interfaces."ve-+".allowedTCPPorts = [ config.services.prometheus.exporters.node.port ];
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
  };

  security.polkit.enable = true;

  containers = {
    prometheus = {
      autoStart = true;
      privateUsers = "pick";
      privateNetwork = true;
      hostAddress = "192.168.100.1";
      localAddress = "192.168.100.11";
      config = { cfg, pkgs, lib, ...}: {
        system.stateVersion = "25.05";
        services.prometheus = {
          enable = true;
          globalConfig.scrape_interval = "20s";
          scrapeConfigs = [
            {
              job_name = "node";
              static_configs = [{
                targets = ["192.168.100.1:${toString config.services.prometheus.exporters.node.port}"];
              }];
            }
          ];
        };
	networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [9090];
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

