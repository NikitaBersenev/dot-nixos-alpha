# modules/misc/theme.nix
{ lib, config, pkgs, ... }:

let
  cfg = config.profiles.misc.theme;
in
{
  options.profiles.misc.theme = {
    enable = lib.mkEnableOption "Глобальная тёмная тема";

    gtkTheme = lib.mkOption {
      type = lib.types.str;
      default = "Adwaita-dark";
      description = "GTK тема";
    };

    iconTheme = lib.mkOption {
      type = lib.types.str;
      default = "Papirus-Dark";
      description = "Тема иконок";
    };

    cursorTheme = lib.mkOption {
      type = lib.types.str;
      default = "Breeze_Snow";
      description = "Тема курсора";
    };
  };

  config = lib.mkIf cfg.enable {
    # GTK настройки для всех пользователей
    environment.gtk = {
      enable = true;
      theme = {
        name = cfg.gtkTheme;
        package = pkgs.gnome-themes-extra;
      };
      iconTheme = {
        name = cfg.iconTheme;
        package = pkgs.papirus-icon-theme;
      };
    };

    # Qt/KDE настройки
    qt = {
      enable = true;
      platformTheme = "gtk";
      style = if (config.services.desktopManager.plasma6.enable or false) then "breeze" else "adwaita-dark";
    };

    # Глобальные переменные окружения
    environment.variables = {
      GTK_THEME = cfg.gtkTheme;
      QT_STYLE_OVERRIDE = "adwaita-dark";
      QT_QPA_PLATFORMTHEME = "gtk3";
    };

    # Установка тем
    environment.systemPackages = with pkgs; [
      gnome-themes-extra
      papirus-icon-theme
      libsForQt5.breeze-qt5
      libsForQt5.breeze-icons
      plasma6Packages.breeze
      plasma6Packages.breeze-icons
    ];
  };
}
