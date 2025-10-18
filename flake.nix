{
  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    papis = {
      url = "github:papis/papis";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    papis-zotero = {
      url = "github:papis/papis-zotero";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{self, nixpkgs-unstable, nixpkgs, nix-darwin, home-manager, ...}:
    let
      secrets = builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
    in {
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
          {
            nixpkgs.overlays = [
              (_: prev: {
                tailscale = prev.tailscale.overrideAttrs (old: {
                  checkFlags =
                    builtins.map (
                      flag:
                        if prev.lib.hasPrefix "-skip=" flag
                        then flag + "|^TestGetList$|^TestIgnoreLocallyBoundPorts$|^TestPoller$"
                        else flag
                    )
                    old.checkFlags;
                });
              })
            ];
          }
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
  };
}
