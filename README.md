# NixOS 

## Use


```bash
sudo nixos-rebuild switch --flake .#alpha
sudo nixos-rebuild switch --flake .#lenovo
```

## Tree

```
.
├── README.md
├── flake.lock
├── flake.nix
├── home-manager
│   └── home.nix
└── nixos
    ├── configuration.nix
    ├── hardware-configuration.nix
    └── modules
        ├── desktop-gnome.nix
        ├── desktop-hyprland.nix
        ├── desktop-kde.nix
        └── nvidia.nix
```
