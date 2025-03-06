# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib,... }:

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
      #inputs.xremap.nixosModules.default
    ];

  # Bootloader
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    #extraModulePackages = with config.boot.kernelPackages; [
    #  v4l2loopback # for OBS virtual camera
    #];
    #extraModprobeConfig = ''
    #  options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    #'';
  };

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

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc
      ];
      #waylandFrontend = true;
    };
  };

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Display Manager
  services.displayManager = {
    autoLogin.user = "marimo";
    defaultSession = "steam";
  };
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeter.enable = false; # autologin
  };

  #programs.hyprland = {
  #  enable = true;
  #};
  #xdg.portal = {
  #  enable = true;
  #  extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  #};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marimo = {
    isNormalUser = true;
    description = "marimo";
    extraGroups = [ "audio" "input" "networkmanager" "wheel" "lp" "libvirtd" "gamemode"];
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    mangohud
  ];

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession = {
        enable = true;
        args = ["-r" "60" "-W" "1920" "-H" "1080" "--mangoapp" "--xwayland-count" "2"];
        env = {
          STEAM_MULTIPLE_XWAYLANDS = "1";
        };
      };
      fontPackages = with pkgs; [ source-han-sans ];
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
      };
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    git = {
      enable = true;
    };
  };

  fonts = {
    packages = with pkgs; [
      source-han-sans
      source-han-mono
      source-han-serif
      noto-fonts-emoji
      (nerdfonts.override { fonts = ["NerdFontsSymbolsOnly"]; })
      udev-gothic-nf
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = ["Source Han Sans" "Noto Color Emoji"];
        sansSerif = ["Source Han Serif" "Noto Color Emoji"];
        monospace = ["Source Han Mono" "Noto Color Emoji"];
        emoji = ["Noto Color Emoji"];
      };
      allowBitmaps = false;
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

  #services.xremap = {
  #  userName = "marimo";
  #  serviceMode = "system";
  #  config.modmap = [
  #    {
  #      name = "SandS";
  #      remap = {
  #        Space = {
  #          alone = "Space";
  #          held = "Shift_L";
  #        };
  #      };
  #    }
  #    {
  #      name = "Capslock to Henkan";
  #      remap = {
  #        CapsLock = "Henkan";
  #      };
  #    }
  #  ];
  #};

  # Local LLM
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    rocmOverrideGfx = "10.3.4";
    user = "ollama";
    group = "ollama";
    home = "/home/ollama/";
  };
  systemd.services.ollama.serviceConfig =
    let
      cfg = config.services.ollama;
      ollamaPackage = cfg.package.override { inherit (cfg) acceleration; };
    in
    lib.mkForce {
      Type = "exec";
      ExecStart = "${lib.getExe ollamaPackage} serve";
      WorkingDirectory = cfg.home;
      SupplementaryGroups = [ "render" ];
    };
  services.open-webui = {
    enable = true;
    host = "0.0.0.0"; # accepts all cilents, but restricted to the tailscale network by FW
    port = 10001;
  };

  # Paperless
  services.paperless = {
    enable = true;
    user = "paperless";
    dataDir = "/home/paperless/";
    address = "0.0.0.0"; # sams as open-webui port above
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
    pulse.enable = true;
  };

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
    # waydroid.enable = true;
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
