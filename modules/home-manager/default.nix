{ lib, config, inputs, ... }:

let
  cfg = config.profiles.home.habe;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.profiles.home.habe = {
    enable = lib.mkEnableOption "Home Manager config for user habe";
  };



  config = lib.mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = {
        inherit inputs;
      };


      sharedModules = [
        inputs.caelestia-shell.homeManagerModules.default
      ];

      users.habe = import ./home.nix;
    };
  };
}

