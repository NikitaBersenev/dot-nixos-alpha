{ lib, config, ... }:

let
  cfg = config.profiles.networking.base;
in
{
  options.profiles.networking.base = {
    enable = lib.mkEnableOption "Base networking";

    hostName = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = "Имя хоста (networking.hostName).";
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      hostName = cfg.hostName;
      networkmanager.enable = true;
    };
  };
}

