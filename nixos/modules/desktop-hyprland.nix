{ lib, config, pkgs, ... }:
let
  cfg    = config.profiles.desktop.hyprland;
  kde    = lib.attrByPath [ "profiles" "desktop" "kde"   "enable" ] false config;
  gnome  = lib.attrByPath [ "profiles" "desktop" "gnome" "enable" ] false config;
  nvidia = lib.attrByPath [ "profiles" "nvidia" "enable" ] false config;
in
{
  options.profiles.desktop.hyprland = {
    enable  = lib.mkEnableOption "Hyprland (Wayland)";
    wayland = lib.mkOption {
      type = lib.types.bool;
      default = true;  # SDDM на Wayland (экспериментально)
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
      message   = "Включите только ОДИН DE/WM: profiles.desktop.hyprland ИЛИ ...kde ИЛИ ...gnome.";
    }];

    # Системный модуль Hyprland (создаёт .desktop для DM, настраивает порталы и т.д.)
    programs.hyprland = {
      enable = true;
      xwayland.enable = lib.mkDefault cfg.xwayland;
      withUWSM = lib.mkDefault true;  # рекомендовано в актуальной документации
    };

    # Логин-менеджер: берём SDDM, как и в KDE-профиле
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = lib.mkDefault cfg.wayland;

    # На всякий случай глушим GNOME/KDE
    services.xserver.displayManager.gdm.enable    = lib.mkForce false;
    services.xserver.desktopManager.gnome.enable  = lib.mkForce false;
    services.desktopManager.plasma6.enable        = lib.mkForce false;

    # Полезно для Electron/Chromium под Wayland
    environment.sessionVariables = lib.mkMerge [
      { NIXOS_OZONE_WL = lib.mkDefault "1"; }
      # Рекомендации для NVIDIA + wlroots (если включён ваш профайл NVIDIA)
      (lib.mkIf nvidia {
        GBM_BACKEND                 = lib.mkDefault "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME   = lib.mkDefault "nvidia";
        WLR_NO_HARDWARE_CURSORS     = lib.mkDefault "1";
      })
    ];
  };
}

