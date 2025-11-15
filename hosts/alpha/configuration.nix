{ inputs, config, pkgs, ... }:

let
  myPython = pkgs.python3.withPackages (ps: with ps; [
    ipykernel
    notebook
    jupyterlab
    numpy
    pandas
    matplotlib
    seaborn
    scikit-learn
    statsmodels
    tqdm
  ]);
in
{
  ##############################################################################
  ## Imports
  ##############################################################################

  imports = [
    ./hardware-configuration.nix
    ../../modules/default.nix

    inputs.home-manager.nixosModules.home-manager
    inputs.xremap.nixosModules.default
  ];

  ##############################################################################
  ## Boot
  ##############################################################################

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelModules = [ "uinput" ];
  };

  ##############################################################################
  ## Networking
  ##############################################################################

  networking = {
    hostName = "alpha";
    networkmanager.enable = true;
  };

  ##############################################################################
  ## Time & locale
  ##############################################################################

  time.timeZone = "Europe/Volgograd";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS        = "ru_RU.UTF-8";
      LC_IDENTIFICATION = "ru_RU.UTF-8";
      LC_MEASUREMENT    = "ru_RU.UTF-8";
      LC_MONETARY       = "ru_RU.UTF-8";
      LC_NAME           = "ru_RU.UTF-8";
      LC_NUMERIC        = "ru_RU.UTF-8";
      LC_PAPER          = "ru_RU.UTF-8";
      LC_TELEPHONE      = "ru_RU.UTF-8";
      LC_TIME           = "ru_RU.UTF-8";
    };
  };

  ##############################################################################
  ## Users
  ##############################################################################

  users.users.habe = {
    isNormalUser = true;
    description  = "habe";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "input"
      "vboxusers"
      "docker"
      "disk"
      "storage"
    ];
    shell    = pkgs.fish;   # логин-шелл всё равно задаём на уровне системы
    packages = [ ];
  };

  ##############################################################################
  ## Input / uinput
  ##############################################################################

  hardware.uinput.enable = true;

  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="input", TAG+="uaccess"
  '';

  ##############################################################################
  ## Graphics / sound / desktop
  ##############################################################################

  services.xserver = {
    enable = true;

    xkb = {
      layout  = "us,ru";
      options = "grp:alt_shift_toggle";
      variant = "";
    };
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable      = true;

  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
  };

  ##############################################################################
  ## Flatpak
  ##############################################################################

  services.flatpak.enable = true;

  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path     = [ pkgs.flatpak ];
    script   = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      flatpak install -y flathub ru.yandex.Browser
    '';
  };

  ##############################################################################
  ## xremap (системный сервис, но работает за пользователя)
  ##############################################################################

  services.xremap = {
    enable      = true;
    serviceMode = "user";
    userName    = "habe";

    withKDE = true;
    watch   = true;

    config.keymap = [
      {
        name  = "Win+S -> ghostty";
        remap = {
          "SUPER-s" = {
            launch = [
              "${pkgs.systemd}/bin/systemd-run"
              "--user"
              "--collect"
              "--"
              "${pkgs.ghostty}/bin/ghostty"
            ];
          };
        };
      }
    ];
  };

  ##############################################################################
  ## Home-manager integration
  ##############################################################################

  home-manager = {
    extraSpecialArgs = {
      inherit inputs ;
    };
    users.habe = import ../../modules/home-manager/home.nix;
  };

  ##############################################################################
  ## Profiles (десктопы/драйверы)
  ##############################################################################

  profiles.desktop.kde.enable = true;
  # profiles.desktop.gnome.enable    = true;
  # profiles.desktop.hyprland.enable = true;

  profiles.nvidia = {
    enable      = true;
    cudaPackage = pkgs.cudaPackages_12_8.cudatoolkit;
  };

  ##############################################################################
  ## Nix / системные программы
  ##############################################################################

  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;
  programs.fish.enable = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      max-substitution-jobs = 32;
      http-connections      = 50;
      max-jobs              = "auto";
      cores                 = 0;
    };

    nixPath = [
      "nixpkgs=${toString pkgs.path}"
      "nixos-config=/etc/nixos/configuration.nix"
    ];
  };

  ##############################################################################
  ## Services (system-wide)
  ##############################################################################

  services.openssh = {
    enable       = true;
    openFirewall = true;
    settings = {
      PermitRootLogin              = "no";
      PasswordAuthentication       = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding                = false;
      AllowTcpForwarding           = "yes";
    };
  };

  services.jupyter = {
    enable      = true;
    command     = "jupyter-lab";
    user        = "habe";
    group       = "users";
    ip          = "0.0.0.0";
    port        = 8888;
    notebookDir = "/home/habe/notebooks";
    password    = "argon2:$argon2id$v=19$m=10240,t=10,p=8$3JV0zWyXjdqyBtSSMo/iPg$B7C24pNyHYe4whuXo5fwy9oA9jfAILMwzZo2+Gh34YY";

    extraEnvironmentVariables = {
      BROWSER_PATH = "${pkgs.google-chrome}/bin/google-chrome-stable";
    };

    kernels = {
      python3 = {
        displayName = "Python 3 (Nix)";
        language    = "python";
        argv = [
          "${myPython.interpreter}"
          "-m"
          "ipykernel_launcher"
          "-f"
          "{connection_file}"
        ];
      };
    };
  };

  virtualisation.docker.enable = true;

  ##############################################################################
  ## Misc
  ##############################################################################

  system.stateVersion = "25.05";

  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates  = "weekly";
}

