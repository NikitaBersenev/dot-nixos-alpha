# ./desktop/desktop-cinnamon.nix
{ lib, config, pkgs, ... }:
let
  cfg = config.profiles.desktop.cinnamon;
  # Check if any other desktop is enabled to prevent conflicts
  kde = lib.attrByPath [ "profiles" "desktop" "kde" "enable" ] false config;
  gnome = lib.attrByPath [ "profiles" "desktop" "gnome" "enable" ] false config;
  hyprland = lib.attrByPath [ "profiles" "desktop" "hyprland" "enable" ] false config;
in
{
  options.profiles.desktop.cinnamon = {
    enable = lib.mkEnableOption "Cinnamon Desktop with LightDM";
  };

  config = lib.mkIf cfg.enable {
    # Assertion to ensure only one desktop is active[citation:1][citation:3]
    assertions = [{
      assertion = (!kde) && (!gnome) && (!hyprland);
      message = "Enable only ONE desktop: either profiles.desktop.cinnamon, .kde, .gnome, or .hyprland.";
    }];

    # Enable the X Window System (required for Cinnamon)[citation:2][citation:4]
    services.xserver.enable = true;

    # Enable LightDM display manager and Cinnamon desktop manager[citation:1][citation:7]
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.desktopManager.cinnamon.enable = true;

    # Set Cinnamon as the default session (important for login)[citation:1]
    services.xserver.displayManager.defaultSession = "cinnamon";

    # Disable other display managers and desktop managers to prevent conflicts
    services.xserver.displayManager.gdm.enable = lib.mkForce false;
    services.xserver.displayManager.sddm.enable = lib.mkForce false;
    services.xserver.desktopManager.gnome.enable = lib.mkForce false;
    services.xserver.desktopManager.plasma6.enable = lib.mkForce false;
  };
}
