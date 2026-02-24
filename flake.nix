{
  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim = {
      url = "github:marimo-KD/neovim-config";
      # inputs.nixpkgs.follows = "nixpkgs"; # see https://github.com/NotAShelf/nvf/issues/1312
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    quadlet-nix = {
      url = "github:SEIAROTg/quadlet-nix";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs-unstable,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
    in
    {
      nixosConfigurations = {
        monix = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs secrets;
          };
          modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.marimo = import ./home/linux.nix;
              nixpkgs.overlays = [
                inputs.emacs-overlay.overlay
              ];
            }
            ./hosts/monix
          ];
        };
        bmax = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs secrets;
          };
          modules = [
            inputs.quadlet-nix.nixosModules.quadlet
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = { inherit secrets; }; }
            ./hosts/bmax
          ];
        };
      };
      darwinConfigurations = {
        malus = nix-darwin.lib.darwinSystem rec {
          system = "aarch64-darwin";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.marimo = import ./home/darwin.nix;
              nixpkgs.overlays = [
                inputs.emacs-overlay.overlay
                (final: prev: {
                  ghostscript = inputs.nixpkgs-unstable.legacyPackages.${prev.system}.ghostscript;
                })
              ];
            }
            ./hosts/malus
          ];
        };
      };
    }
    // inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      imports = [ inputs.treefmt-nix.flakeModule ];
      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              nixd
              git-crypt
            ];
          };
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
            };
          };
        };
    };
}
