{
  description = "NixOS Alpha";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, xremap, ... } @ inputs:
  let
    system = "x86_64-linux";

    mkHost = hostPath:
      nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit system inputs;
        };

        modules = [ hostPath ];
      };
  in {
    nixosConfigurations = {
      alpha  = mkHost ./hosts/alpha/configuration.nix;
      lenovo = mkHost ./hosts/lenovo/configuration.nix;
    };
  };
}

