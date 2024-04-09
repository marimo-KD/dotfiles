# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      # <nixpkgs/nixos/modules/services/hardware/sane_extrabackends/brscan4.nix>
      ./hardware-configuration.nix
    ] ++ (with inputs.nixos-hardware.nixosModules; [
      common-cpu-amd
      common-gpu-amd
      common-pc-ssd
    ]) ++ [
      inputs.xremap.nixosModules.default
    ];

  hardware.opengl.enable = true;
  hardware.opentabletdriver.enable = true;
  hardware.sane = {
    enable = true;
    brscan4 = {
      enable = true;
      netDevices = {};
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod;

  networking.hostName = "monix"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = [pkgs.fcitx5-skk-qt pkgs.fcitx5-gtk pkgs.libsForQt5.fcitx5-qt];
  };
  services.dbus.packages = [config.i18n.inputMethod.package];

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marimo = {
    isNormalUser = true;
    description = "marimo";
    extraGroups = [ "networkmanager" "wheel" "scanner" "lp" "libvirtd"];
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    curl
    lm_sensors
  ];

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
      ];
    };
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };
    gamemode = {
      enable = true;
      settings = {
        gpu = {
          #apply_gpu_optimisations = 0;
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          amd_performance_level = "high";
        };
      };
    };
    gamescope = { enable = true; };
    git = { enable = true; };
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-emoji
      source-han-sans
      source-han-mono
      source-han-serif
      (nerdfonts.override { fonts = ["Iosevka"]; })
      plemoljp-nf
      ibm-plex
      ipaexfont
      iosevka
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif CJK JP" "Noto Color Emoji"];
        sansSerif = ["Noto Sans CJK JP" "Noto Color Emoji"];
        monospace = ["Iosevka Nerd Font" "Noto Color Emoji"];
        emoji = ["Noto Color Emoji"];
      };
      allowBitmaps = false;
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        <fontconfig>
          <description>Change default fonts for Steam client</description>
          <match>
            <test name="prgname">
              <string>steamwebhelper</string>
            </test>
            <test name="family" qual="any">
              <string>sans-serif</string>
            </test>
            <edit mode="prepend" name="family">
              <string>Migu 1P</string>
            </edit>
          </match>
        </fontconfig>
      '';
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };
  services.tailscale.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = ["tailscale0"];
    allowedUDPPorts = [config.services.tailscale.port];
  };

  # networking.wireguard.interfaces = {
  #   wg0 = {
  #     ips = [ "10.0.101.102/32" "fd34::101::102/128"];
  #     listenPort = 51820;
  #     peers = [
  #       {
  #         publicKey = "BxaOPypP4bSCdYBw+TfhEXPbg6DiIuhmRxtbWGbDEmo=";
  #         allowedIPs = ["192.168.200.0/24" "192.168.220.0/24" "10.0.0.36/32" "fd34::10:0:0:36/128"];
  #         endpoint = "kmc.gr.jp:51820";
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };

  services.xremap = {
    userName = "marimo";
    serviceMode = "system";
    config = {
      modmap = [
        {
          name = "SandS";
          remap = {
            Space = {
              alone = "Space";
              held = "Shift_L";
            };
          };
        }
      ];
    };
  };

  # support printers
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
  };
  programs.noisetorch.enable = true;

  services.flatpak.enable = true;

  services.dbus.enable = true;
  xdg = {
    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
      config.common.default = "*";
    };
  };
  security.polkit.enable = true;

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    waydroid.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pqxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;
}
