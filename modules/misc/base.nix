# modules/misc/base.nix
{ lib, config, pkgs, ... }:

let
  cfg = config.profiles.misc.base;
in
{
  options.profiles.misc.base = {
    enable = lib.mkEnableOption "Base misc system config (boot, time, locale, nix, uinput, upgrades)";

    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "Europe/Volgograd";
      description = "Системный часовой пояс.";
    };
  };

  config = lib.mkIf cfg.enable {
    ############################################################################
    ## Boot
    ############################################################################
    boot = {
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      kernelModules = [ "uinput" ];
    };

    ############################################################################
    ## Time & locale
    ############################################################################
    time.timeZone = cfg.timeZone;

    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "ru_RU.UTF-8";
        LC_IDENTIFICATION = "ru_RU.UTF-8";
        LC_MEASUREMENT = "ru_RU.UTF-8";
        LC_MONETARY = "ru_RU.UTF-8";
        LC_NAME = "ru_RU.UTF-8";
        LC_NUMERIC = "ru_RU.UTF-8";
        LC_PAPER = "ru_RU.UTF-8";
        LC_TELEPHONE = "ru_RU.UTF-8";
        LC_TIME = "ru_RU.UTF-8";
      };
    };

    ############################################################################
    ## Input / uinput
    ############################################################################
    hardware.uinput.enable = true;

    services.udev.extraRules = ''
      KERNEL=="uinput", GROUP="input", TAG+="uaccess"
    '';

    ############################################################################
    ## Nix / системные настройки
    ############################################################################
    nixpkgs.config.allowUnfree = true;

    programs.nix-ld.enable = true;

    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];

        max-substitution-jobs = 32;
        http-connections = 50;
        max-jobs = "auto";
        cores = 0;
      };

      nixPath = [
        "nixpkgs=${toString pkgs.path}"
        "nixos-config=/etc/nixos/configuration.nix"
      ];
    };

    ############################################################################
    ## Auto upgrade
    ############################################################################
    system.autoUpgrade = {
      enable = true;
      dates = "weekly";
    };
  };
}

