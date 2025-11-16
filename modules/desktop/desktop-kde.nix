{ lib, config, pkgs, ... }:
let
  cfg = config.profiles.desktop.kde;
  gnome = lib.attrByPath [ "profiles" "desktop" "gnome" "enable" ] false config;
in
{
  options.profiles.desktop.kde = {
    enable = lib.mkEnableOption "KDE Plasma 6 + SDDM";
    wayland = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Включить SDDM на Wayland (экспериментально).";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = !gnome;
      message = "Включите только ОДИН DE: либо profiles.desktop.kde.enable, либо profiles.desktop.gnome.enable.";
    }];

    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    services.displayManager.sddm.wayland.enable = lib.mkDefault cfg.wayland;

    services.xserver.displayManager.gdm.enable = lib.mkForce false;
    services.xserver.desktopManager.gnome.enable = lib.mkForce false;
  };
}

