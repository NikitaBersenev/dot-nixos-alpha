# modules/driver/driver-nvidia.nix
{ lib, config, pkgs, ... }:
let
  cfg = config.profiles.nvidia;
in
{
  options.profiles.nvidia = {
    enable = lib.mkEnableOption "общий стек NVIDIA";

    cudaPackage = lib.mkOption {
      type = with lib.types; nullOr package;
      default = null;
      description = "Пакет CUDA Toolkit для установки (или null, чтобы не ставить).";
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];

    hardware.graphics.enable = true;

    hardware.nvidia = {
      open = lib.mkDefault true;
      modesetting.enable = lib.mkDefault true;
    };

    boot.blacklistedKernelModules = lib.mkDefault [ "nouveau" ];

    environment.systemPackages =
      lib.optionals (cfg.cudaPackage != null) [ cfg.cudaPackage ];
  };
}

