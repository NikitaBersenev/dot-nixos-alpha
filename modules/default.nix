{ ... }:

{
  imports = [
    # Desktop profiles
    ./desktop/desktop-gnome.nix
    ./desktop/desktop-hyprland.nix
    ./desktop/desktop-kde.nix

    # Drivers
    ./driver/driver-nvidia.nix

    # Core system / misc
    ./misc/base.nix

    # Networking
    ./networking/base.nix

    # Users
    ./user/habe.nix

    # Services
    ./services/core.nix
    ./services/jupyter.nix
    ./services/xremap.nix

    # Home-manager integration
    ./home-manager/default.nix
    
    ./desktop/desktop-cinnamon.nix
  ];
}

