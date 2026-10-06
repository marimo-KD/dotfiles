# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  inputs,
  config,
  lib,
  pkgs,
  secrets,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = 0;
  };

  networking.hostName = "bmax"; # Define your hostname.
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.marimo = {
    isNormalUser = true;
    home = "/home/marimo";
    extraGroups = [ "wheel" ];
  };

  home-manager.users.marimo =
    { ... }:
    {
      imports = [ ../../home/programs/helix ];
      home.stateVersion = "25.05";
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

  users.groups.podman = { };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
  ];

  services.tailscale = {
    enable = true;
    openFirewall = true; # Open a UDP Port that tailscale uses.
    useRoutingFeatures = "both";
    extraSetFlags = [
      "--accept-dns=false"
    ];
  };

  services.cloudflared = {
    enable = true;
    certificateFile = "/home/marimo/.cloudflared/cert.pem";
    tunnels.bmax0 = {
      default = "http_status:404";
      credentialsFile = "/home/marimo/.cloudflared/3cbf78f1-2bb7-482d-99ea-e7dd3994d0c9.json";
    };
  };

  services.prometheus.exporters.node = {
    enable = false;
    port = 9000;
    enabledCollectors = [ "systemd" ];
  };

  # services.resolved.enable = true; # see https://github.com/tailscale/tailscale/issues/4254

  security.polkit.enable = true;

  networking = {
    useDHCP = false;
    interfaces."enp2s0".useDHCP = true;
    nameservers = [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ]; # allow connections come from tailscale network.
    };
  };

  virtualisation.quadlet.enable = true;
  virtualisation.podman.defaultNetwork.settings.dns_enabled = true;

  home-manager.users.podman =
    { ... }:
    {
      imports = [
        inputs.quadlet-nix.homeManagerModules.quadlet
        ./containers/traefik.nix
        ./containers/couchdb.nix
        ./containers/opencloud.nix
        ./containers/forgejo.nix
        ./containers/fastnotesync.nix
        ./containers/silverbullet.nix
        ./containers/zotero-translator.nix
      ];
      home.stateVersion = "25.05";
      virtualisation.quadlet = {
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
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  nixpkgs.config.allowUnfree = true;
}
