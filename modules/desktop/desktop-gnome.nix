{ lib, config, pkgs, ... }:
let
  cfg = config.profiles.desktop.gnome;
  kde = lib.attrByPath [ "profiles" "desktop" "kde" "enable" ] false config;
in
{
  options.profiles.desktop.gnome = {
    enable = lib.mkEnableOption "GNOME + GDM";
    wayland = lib.mkOption {
      type = lib.types.bool;
      default = true; # GDM Wayland по умолчанию
      description = "Включить Wayland в GDM (false — форсировать Xorg).";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = !kde;
      message = "Включите только ОДИН DE: либо profiles.desktop.kde.enable, либо profiles.desktop.gnome.enable.";
    }];

    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.wayland = lib.mkDefault cfg.wayland;


    services.displayManager.sddm.enable = lib.mkForce false;
    services.desktopManager.plasma6.enable = lib.mkForce false;
  };
}

