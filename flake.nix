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


    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, xremap, caelestia-shell, ... } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      mkHost = hostPath:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit system inputs;
          };

          modules = [

            hostPath


            {
              nixpkgs.overlays = [
                (final: prev: {
                  caelestia-shell = caelestia-shell.packages.${system}.caelestia-shell;
                  caelestia-cli = caelestia-shell.inputs.caelestia-cli.packages.${system}.caelestia-cli;
                })
              ];
            }

          ];
        };
    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;
      nixosConfigurations = {
        alpha = mkHost ./hosts/alpha/configuration.nix;
        lenovo = mkHost ./hosts/lenovo/configuration.nix;
      };
    };
}

