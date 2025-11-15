{ lib, config, pkgs, ... }:

let
  cfg = config.profiles.user.habe;
in
{
  options.profiles.user.habe = {
    enable = lib.mkEnableOption "User habe";
  };

  config = lib.mkIf cfg.enable {
    users.users.habe = {
      isNormalUser = true;
      description  = "habe";
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "input"
        "vboxusers"
        "docker"
        "disk"
        "storage"
      ];
      shell    = pkgs.fish;
      packages = [ ];
    };

    programs.fish.enable = true;
  };
}

