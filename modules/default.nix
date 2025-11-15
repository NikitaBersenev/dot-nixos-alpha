# modules/default.nix
{ ... }:

{
  imports = [
    ./desktop/desktop-gnome.nix
    ./desktop/desktop-hyprland.nix
    ./desktop/desktop-kde.nix
    ./driver/driver-nvidia.nix
  ];
}

