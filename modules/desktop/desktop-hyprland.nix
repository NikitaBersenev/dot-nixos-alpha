{ lib, config, pkgs, ... }:
let
  cfg = config.profiles.desktop.hyprland;
  kde = lib.attrByPath [ "profiles" "desktop" "kde" "enable" ] false config;
  gnome = lib.attrByPath [ "profiles" "desktop" "gnome" "enable" ] false config;
  nvidia = lib.attrByPath [ "profiles" "nvidia" "enable" ] false config;
in
{
  options.profiles.desktop.hyprland = {
    enable = lib.mkEnableOption "Hyprland (Wayland)";
    wayland = lib.mkOption {
      type = lib.types.bool;
      default = true; # SDDM на Wayland (экспериментально)
      description = "Запускать SDDM на Wayland. На саму сессию Hyprland (всегда Wayland) не влияет.";
    };
    xwayland = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Включить XWayland внутри Hyprland.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [{
      assertion = (!kde) && (!gnome);
      message = "Включите только ОДИН DE/WM: profiles.desktop.hyprland ИЛИ ...kde ИЛИ ...gnome.";
    }];

    programs.hyprland = {
      enable = true;
      xwayland.enable = lib.mkDefault cfg.xwayland;
      withUWSM = lib.mkDefault true;
    };

    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = lib.mkDefault cfg.wayland;

    services.displayManager.gdm.enable = lib.mkForce false;
    services.desktopManager.gnome.enable = lib.mkForce false;
    services.desktopManager.plasma6.enable = lib.mkForce false;

    environment.sessionVariables = lib.mkMerge [
      { NIXOS_OZONE_WL = lib.mkDefault "1"; }
      (lib.mkIf nvidia {
        GBM_BACKEND = lib.mkDefault "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = lib.mkDefault "nvidia";
        WLR_NO_HARDWARE_CURSORS = lib.mkDefault "1";
      })
    ];
  };
}

