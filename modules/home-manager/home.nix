{ config, pkgs, lib, ... }:

{
  home.username = "habe";
  home.homeDirectory = "/home/habe";
  home.stateVersion = "24.11";

  ##############################################################################
  ## Packages
  ##############################################################################

  nixpkgs.config.allowUnfree = true;

  home.packages =
    (with pkgs; [
      # New 
      kdePackages.qtsvg
      virt-manager
      swww
      waypaper

      kdePackages.kio-fuse #to mount remote filesystems via FUSE
      kdePackages.kio-extras #extra protocols support (sftp, fish and more)
      kdePackages.dolphin # This is the actual dolphin package
      age
      hyprpaper
      cmake
      ninja


      #caelestia-shell
      #caelestia-cli
      ddcutil
      brightnessctl
      app2unit
      libcava
      networkmanager
      fish
      aubio
      glibc
      material-symbols
      swappy
      bash

      gh
      gcc
      htop
      discord-ptb
      openvpn
      appimage-run
      haruna
      nixpkgs-fmt

      # Editors & terminals
      vim
      nixfmt
      neovim
      vscode
      kitty
      alacritty
      ghostty
      wezterm
      home-manager

      # Fonts
      nerd-fonts.jetbrains-mono

      # GUI apps
      obs-studio
      google-chrome
      firefox
      telegram-desktop

      # Shell
      fish
      fishPlugins.done
      fishPlugins.fzf-fish
      fishPlugins.grc
      fishPlugins.tide
      fzf
      grc

      # CLI utils
      wl-clipboard
      bat
      gnupg
      git
      git-crypt
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
      flatpak
      xremap
      xbindkeys

      # Dev tools
      go
      gopls
      nodejs
      gnumake
      binutils
      ollama
      uv

      # Containers & virtualization
      docker
      docker-compose
      qemu-utils
      qemu_kvm
      OVMF

      (pkgs.python3.withPackages (ps: with ps; [
        pip
        ipykernel
        notebook
        jupyterlab
      ]))
    ]);
  ##############################################################################
  ## Programs
  ##############################################################################

  programs.home-manager.enable = true;

  programs.firefox.enable = true;

  programs.fish = {
    enable = true;
  };

  #systemd.user.services.caelestia-shell = {
  # Unit = {
  #   Description = "caelestia shell daemon";
  #   PartOf = [ "graphical-session.target" ];
  #   After = [ "graphical-session.target" ];
  # };
  # Service = {
  #   ExecStart = "${pkgs.caelestia-shell}/bin/caelestia shell -d";
  #   Restart = "on-failure";
  #   Environment = "DISPLAY=:0;WAYLAND_DISPLAY=wayland-0"; # Важно!
  # };
  # Install = {
  #   WantedBy = [ "graphical-session.target" ];
  # };
  #};

  #  programs.caelestia = {
  #    enable = true;
  #
  #    systemd = {
  #      enable = true;
  #      target = "graphical-session.target";
  #      environment = [ ];
  #    };
  #
  #    settings = {
  #      bar.status = {
  #        showBattery = false;
  #      };
  #      paths.wallpaperDir = "~/Images";
  #    };
  #
  #    cli = {
  #      enable = true; 
  #      settings = {
  #        theme.enableGtk = false;
  #      };
  #    };
  #  };

  home.activation.enableMinimizeAll = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
      --file kwinrc \
      --group Plugins \
      --key minimizeallEnabled \
      true
  '';


  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      #exec-once = [
      #  "caelestia shell -d"
      #];

      monitor = ",preferred,auto,1";

      # Input
      input = {
        kb_layout = "us,ru";
        kb_options = "grp:alt_shift_toggle";
        follow_mouse = 1;
      };

      "$mod" = "SUPER";

      bind = [
        # Switch workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move window to workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Window management
        "$mod, q, killactive," # close window
        "$mod, f, fullscreen," # toggle fullscreen
        "$mod, m, togglefloating," # toggle float
        "$mod, d, exit," # exit Hyprland (default dialog)
        "$mod SHIFT, q, killactive," # alternative close

        # Layout & focus
        "$mod, h, movefocus, l" # ←
        "$mod, l, movefocus, r" # →
        "$mod, k, movefocus, u" # ↑
        "$mod, j, movefocus, d" # ↓

        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"

        "$mod, Return, exec, ${pkgs.ghostty}/bin/ghostty"
        "$mod, t, exec, ${pkgs.ghostty}/bin/ghostty"
      ];

      #  decoration = {
      #    rounding = 10;
      #    blur = {
      #      enabled = true;
      #      size = 3;
      #      passes = 1;
      #    };
      #  };

      #  # Animations
      #  animations = {
      #    enabled = true;
      #    bezier = "default, 0.05, 0.9, 0.1, 1.05";
      #    animation = [
      #      "windows, 1, 7, default"
      #      "border, 1, 10, default"
      #      "fade, 1, 7, default"
      #    ];
      #  };
    };
  };
  ##############################################################################
  ## xbindkeys 
  ##############################################################################



  home.file.".xbindkeysrc".text = ''
    # Win (Mod4) + s -> запустить ghostty
    "ghostty"
      Mod4 + s
  '';

  systemd.user.services.xbindkeys = {
    Unit = {
      Description = "xbindkeys daemon for global hotkeys";
      PartOf = [ "graphical-session.target" ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.xbindkeys}/bin/xbindkeys";
      Restart = "always";
    };
  };

  ##############################################################################
  ## Misc
  ##############################################################################

  # home.file = home.file or { };
  # home.sessionVariables = home.sessionVariables or { };
}

