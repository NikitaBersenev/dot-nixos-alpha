# NixOS 

## Use


```bash
sudo nixos-rebuild switch --flake .#alpha
sudo nixos-rebuild switch --flake .#lenovo
```

## Develop

```bash
nix fmt ./**/*.nix
```

## Tree

```
.
├── README.md
├── flake.lock
├── flake.nix
├── hosts
│   ├── alpha
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── lenovo
│       └── configuration.nix
└── modules
    ├── default.nix
    ├── desktop
    │   ├── desktop-gnome.nix
    │   ├── desktop-hyprland.nix
    │   └── desktop-kde.nix
    ├── driver
    │   └── driver-nvidia.nix
    ├── home-manager
    │   ├── default.nix
    │   └── home.nix
    ├── misc
    │   └── base.nix
    ├── networking
    │   └── base.nix
    ├── services
    │   ├── core.nix
    │   ├── jupyter.nix
    │   └── xremap.nix
    └── user
        └── habe.nix
```
