{
  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    xremap.url = "github:xremap/nix-flake";
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs@{self, nixpkgs-unstable, nixpkgs, nix-darwin, home-manager, ...} : {
    nixosConfigurations = {
      monix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
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
          inputs.musnix.nixosModules.musnix
          ./hosts/monix
        ];
      };
    };
    darwinConfigurations = {
      malus = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.marimo = import ./home/darwin.nix;
            nixpkgs.overlays = [
              inputs.nixpkgs-firefox-darwin.overlay
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
