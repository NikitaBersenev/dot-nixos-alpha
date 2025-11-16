{ config, pkgs, ... }:

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
      age
      gcc
      htop
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

