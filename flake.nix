{
  description = "Home Manager configuration of habe";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, home-manager, ... } @ inputs:
    let
      system = "x86_64-linux";
      #pkgs = nixpkgs.legacyPackages.${system};
	pkgs = import nixpkgs {
		inherit system;
		config = {
			allowUnfree = true;
		};
	};

    in
    {
      homeConfigurations."habe" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
	inherit system;
	specialArgs = { inherit system inputs; };

        modules = [ 
	./nixos/configuration.nix
	./home-manager/home.nix 

	];
      };
    };
}




