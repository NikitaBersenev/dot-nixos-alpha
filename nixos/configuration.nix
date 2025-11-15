# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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
    # add others as needed
  ]);
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix


    #./modules/desktop-gnome.nix
    ./modules/desktop-kde.nix
    # ./modules/desktop-hyprland.nix

    ./modules/nvidia.nix
    #inputs.home-manager.nixosModules.home-manager
    
    inputs.home-manager.nixosModules.home-manager
    inputs.xremap.nixosModules.default
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.blacklistedKernelModules = [ "nouveau" ]; # Optional but recommended to avoid conflicts

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Volgograd";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
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

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver = {
    enable = true;               # Enable the X11 windowing system.
    videoDrivers = [ "nvidia" ]; # Specify "nvidia" driver

    xkb = {
      layout  = "us,ru";
      options = "grp:alt_shift_toggle";
      variant = "";
    };
  };

  # Enable the KDE Plasma Desktop Environment.
 # services.displayManager.sddm.enable = true;
 #  services.desktopManager.plasma6.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable      = true;
  services.pipewire = {
    enable          = true;
    alsa.enable     = true;
    alsa.support32Bit = true;
    pulse.enable    = true;
    # If you want to use JACK applications, uncomment this:
    # jack.enable = true;
  };

  # Enable touchpad support (enabled by default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.habe = {
    isNormalUser = true;
    description  = "habe";
    packages = with pkgs; [
      # thunderbird
    ];
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
    shell = pkgs.fish;
  };
   hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];
  services.udev.extraRules = ''
    KERNEL=="uinput", GROUP="input", TAG+="uaccess"
  '';
	

 environment.etc."xbindkeys/xbindkeysrc".text = ''
    # Win (Mod4) + s -> запустить ghostty
    "ghostty"
      Mod4 + s
  '';
    systemd.user.services.xbindkeys = {
    description = "xbindkeys daemon for global hotkeys";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.xbindkeys}/bin/xbindkeys -f /etc/xbindkeys/xbindkeysrc";
    Restart = "always";
  };
};

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      flatpak install flathub ru.yandex.Browser
    '';
  };
  services.xremap = {
    # включаем сервис
    enable = true;

    # на KDE Wayland xremap только как user-service
    serviceMode = "user";
    userName    = "habe";

    # поддержка KDE (Wayland)
    withKDE = true;

    # аналог --watch, чтобы подхватывать новые девайсы
    watch = true;

    # вместо yamlConfig — чистый Nix-attrset
    config = {
      keymap = [
        {
          name  = "Win+S -> ghostty";
          remap = {
            "SUPER-s" = {
              # тот же launch, что у тебя был в YAML
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
  };

	      #launch: ["${pkgs.runtimeShell}", "-lc", "${pkgs.lib.getExe pkgs.ghostty}"]
              #launch: ["${pkgs.lib.getExe pkgs.ghostty}"]
# systemd.user.services.xremap = {
#  description = "xremap key remapper (Super+S -> ghostty)";
#  wantedBy = [ "graphical-session.target" ];
#  partOf   = [ "graphical-session.target" ];
#
#  serviceConfig = {
#    ExecStart = "${pkgs.xremap}/bin/xremap --watch /etc/xremap/config.yml";
#    Restart   = "always";
#  };
#};

  home-manager = {
	extraSpecialArgs = { inherit inputs; };
	users = {
		habe = import ../home-manager/home.nix;
	};
  };
  #profiles.desktop.hyprland.enable  = true;
  profiles.desktop.kde.enable   = true;
  #profiles.desktop.gnome.enable = true;
  profiles.nvidia.enable = true;

  nixpkgs.config.allowUnfree = true;

  hardware.opengl.enable = true;
  hardware.nvidia.open   = true;

  environment.systemPackages = with pkgs; [
    # Editors & terminals
    vim
    home-manager
    gnupg
    git-crypt
    flatpak
    xremap
    xbindkeys
    # xremap
    # kmonad
    # keyd
    obs-studio
    ghostty
    nerd-fonts.jetbrains-mono
    vault
    kitty
    alacritty

    fishPlugins.done
    fishPlugins.fzf-fish
    #fishPlugins.forgit
    #fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc
    fishPlugins.tide


    wl-clipboard
    neovim
    #watershot
    bat
    wezterm
    vscode
    fish

    # Browsers
    google-chrome
    firefox
    telegram-desktop

    # Dev tools
    git
    go
    gopls
    nodejs
    gnumake
    binutils
    #micromamba
    ollama
    uv

    # Containers & virtualization
    docker
    docker-compose
    qemu-utils
    qemu_kvm
    OVMF

    # CUDA
    cudaPackages_12_8.cudatoolkit

    # CLI utils
    curl
    wget
    neofetch
    pigz
    pv
    gnutar
    gzip
    xz
    unzip
    bash
    coreutils
    findutils
    gnugrep
    procps
    go-task
    tre-command
    rainfrog
    wget
    uv

    # Python user env example
    (python3.withPackages (ps: with ps; [
      pip
      ipykernel
      notebook   # классический сервер (для совместимости)
      jupyterlab # современный интерфейс
    ]))
  ];


  programs = {
    firefox.enable = true;

    fish = {
	  enable = true;
	};

    # hyprland = {
    #   enable = true;
    #   xwayland.enable = true;
    # };
  };

  services.jupyter.extraEnvironmentVariables = {
    BROWSER_PATH = "${pkgs.google-chrome}/bin/google-chrome-stable";
  };
 nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';
  nix.nixPath = [
    # используем тот же nixpkgs, что и система
    "nixpkgs=${toString pkgs.path}"
    # и явно указываем, где лежит конфиг NixOS
    "nixos-config=/etc/nixos/configuration.nix"
  ];

  nix.settings = {
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

  services.openssh = {
    enable       = true;
    openFirewall = true;
    settings = {
      PermitRootLogin           = "no";
      PasswordAuthentication    = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding             = false;
      AllowTcpForwarding        = "yes";
    };
  };

  programs.nix-ld.enable = true;

  services.jupyter.kernels.python3 = {
    displayName = "Python 3 (Nix)";
    language    = "python";
    argv = [
      "${myPython.interpreter}" "-m" "ipykernel_launcher" "-f" "{connection_file}"
    ];
  };

  # -----------------------------
  # JupyterLab как системный сервис
  # -----------------------------
  services.jupyter = {
    enable      = true;
    command     = "jupyter-lab";         # можно "jupyter-notebook", если нравится классика
    user        = "habe";                # от какого пользователя запускать
    group       = "users";
    ip          = "0.0.0.0";             # по умолчанию слушаем только localhost
    port        = 8888;
    notebookDir = "/home/habe/notebooks";
    password    = "argon2:$argon2id$v=19$m=10240,t=10,p=8$3JV0zWyXjdqyBtSSMo/iPg$B7C24pNyHYe4whuXo5fwy9oA9jfAILMwzZo2+Gh34YY";
  };

  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default settings
  # for stateful data were taken. It is recommended to keep it at the
  # release version of the first install of this system.
  system.stateVersion = "25.05"; # Did you read the comment?
}

