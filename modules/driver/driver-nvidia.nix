# /etc/nixos/modules/nvidia.nix
{ lib, config, pkgs, ... }:
let
  cfg = config.profiles.nvidia;
in
{
  options.profiles.nvidia = {
    enable = lib.mkEnableOption "общий стек NVIDIA";

    # Опционально: какой CUDA-пакет добавить. Поставьте null, если не нужен.
    cudaPackage = lib.mkOption {
      type = with lib.types; nullOr package;
      default = null;
      description = "Пакет CUDA Toolkit для установки (или null, чтобы не ставить).";
    };
  };

  config = lib.mkIf cfg.enable {
    # Драйвер и графический стек
    services.xserver.videoDrivers = lib.mkDefault [ "nvidia" ];

    # Начиная с 24.11: hardware.opengl → hardware.graphics
    hardware.graphics.enable = true;

    hardware.nvidia = {
      open = lib.mkDefault true;      # open-source kernel module (Turing+)
      modesetting.enable = lib.mkDefault true;
      # nvidiaSettings = true;        # раскомментируйте, если нужна утилита nvidia-settings
      # persistenced = true;          # при необходимости
      # powerManagement.enable = true;# ноутбуки/энергосбережение (экспериментально)
    };

    # Избежать конфликтов с nouveau
    boot.blacklistedKernelModules = lib.mkDefault [ "nouveau" ];

    # Опциональная установка CUDA из опции
    environment.systemPackages =
      lib.optionals (cfg.cudaPackage != null) [ cfg.cudaPackage ];
  };
}

