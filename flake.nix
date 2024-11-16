{
  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    xremap.url = "github:xremap/nix-flake";
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    musnix.url = "github:musnix/musnix";
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
            home-manager.users.marimo = import ./home/linux;
            nixpkgs.overlays = [
              (final: prev: let
                unstable = import nixpkgs-unstable {
                  system = final.system;
                  config.allowUnfree = true;
                }; in
                {
                  mozcdic-ut-neologd = unstable.mozcdic-ut-neologd;
                  mozcdic-ut-jawiki = unstable.mozcdic-ut-jawiki;
                  mozcdic-ut-edict2 = unstable.mozcdic-ut-edict2;
                }
              )
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
            home-manager.users.marimo = import ./home/darwin;
            nixpkgs.overlays = [
              inputs.nixpkgs-firefox-darwin.overlay
            ];
          }
          ./hosts/malus
        ];
      };
    };
  };
}
