{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/default.nix
  ];

  ##############################################################################
  ## Профили
  ##############################################################################

  profiles.networking.base = {
    enable = true;
    hostName = "alpha";
  };

  profiles.misc = {

    base = {
      enable = true;
      timeZone = "Europe/Volgograd";
    };

    theme.enable = true;
  };

  profiles.user.habe.enable = true;
  profiles.desktop.cinnamon.enable = true;
  #profiles.desktop.kde.enable = true;
  # profiles.desktop.kde.enable = false;
  # profiles.desktop.gnome.enable = true;
  # profiles.desktop.gnome.enable = false;
  # profiles.desktop.hyprland.enable = true;
  # profiles.desktop.hyprland.enable = false;


  profiles.nvidia = {
    enable = true;
    cudaPackage = pkgs.cudaPackages_12_8.cudatoolkit;
  };

  profiles.services.core.enable = true;
  profiles.services.jupyter.enable = true;
  profiles.services.xremap.enable = true;

  profiles.home.habe.enable = true;

  programs.thunar.enable = true;
  ##############################################################################
  ## Host-specific
  ##############################################################################

  system.stateVersion = "25.05";
}

