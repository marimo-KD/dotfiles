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

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;

  zramSwap = {
    enable = true;
    memoryPercent = 200;
  };

  networking.hostName = "monix"; # Define your hostname.

  # Enable networking
  systemd.network.enable = true;
  networking.useNetworkd = true;

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

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    videoDrivers = ["amdgpu"];
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.gnome = {
    core-utilities.enable = false;
  };

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gnome-text-editor
    cheese # webcam tool
    gnome-music
    gnome-terminal
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    gnome-calculator
    yelp # help viewer
    gnome-maps
    gnome-weather
    gnome-contacts
  ]);

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marimo = {
    isNormalUser = true;
    description = "marimo";
    extraGroups = [ "audio" "networkmanager" "wheel" "scanner" "lp" "libvirtd" "gamemode"];
    packages = with pkgs; [];
  };

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
      gamescopeSession.enable = true;
    };
    gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          renice = 10;
          inhibit_screensaver = 0;
          disable_splitlock = 1;
          softrealtime = "auto";
        };
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
    dconf.enable = true;
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      source-han-sans
      source-han-mono
      source-han-serif
      (nerdfonts.override { fonts = [
                              "Iosevka"
                              "NerdFontsSymbolsOnly"
                              "JetBrainsMono"
                            ]; })
      plemoljp-nf
      udev-gothic
      ibm-plex
      ipaexfont
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = ["Source Han Serif" "Noto Color Emoji"];
        sansSerif = ["Source Han Sans" "Noto Color Emoji"];
        monospace = ["IBM Plex Mono" "Noto Color Emoji"];
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

  services.syncthing = {
    enable = true;
    user = "marimo";
    dataDir = "/home/marimo/Sync";
    configDir = "/home/marimo/.config/syncthing";
  };

  services.xremap = {
    userName = "marimo";
    serviceMode = "system";
    config.modmap = [
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

  # support printers
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
  };
  programs.noisetorch.enable = true;
  musnix.enable = true;

  services.dbus.enable = true;
  security.polkit.enable = true;

  virtualisation = {
    docker = {
      enable = true;
      daemon.settings = {
        dns = ["8.8.8.8" "8.8.4.4"];
      };
      rootless = {
        enable = true;
        setSocketVariable = true;
        daemon.settings = {
          dns = ["8.8.8.8" "8.8.4.4"];
        };
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
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs.config.allowUnfree = true;
}
