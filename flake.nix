{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    xremap.url = "github:xremap/nix-flake";
    rust-overlay.url = "github:oxalica/rust-overlay";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    #zjstatus.url = "github:dj95/zjstatus";
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    musnix.url = "github:musnix/musnix";
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = inputs@{self, nixpkgs, nixpkgs-stable, nix-darwin, home-manager, ...} : {
    nixosConfigurations = {
      monix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ({...}: {
            nixpkgs.overlays = [
              (final: prev: {
                wireplumber = nixpkgs-stable.legacyPackages.${prev.system}.wireplumber;
              })
            ];
          })
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
          ./hosts/malus
        ];
      };
    };
    homeConfigurations = {
      monixHome = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          ./home/linux
          inputs.catppuccin.homeManagerModules.catppuccin
          {
            catppuccin.flavor = "frappe";
            catppuccin.accent = "pink";
            nixpkgs.overlays = [
              (import inputs.rust-overlay) 
              inputs.neovim-nightly-overlay.overlays.default
            ];
          }
        ];
      };
      malusHome = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
          overlays = [
            (import inputs.rust-overlay)
            inputs.neovim-nightly-overlay.overlays.default
            inputs.nixpkgs-firefox-darwin.overlay
            (final: prev: {
              zjstatus = inputs.zjstatus.packages.${prev.system}.default;
            })
          ];
        };
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          ./home/darwin
          inputs.catppuccin.homeManagerModules.catppuccin
          {
            catppuccin.flavour = "frappe";
            catppuccin.accent = "pink";
          }
        ];
      };
    };
  };
}
