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
      extraSpecialArgs = {
        inherit inputs;
      };

      users.habe = import ./home.nix;
    };
  };
}

