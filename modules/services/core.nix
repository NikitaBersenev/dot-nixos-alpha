# modules/services/core.nix
{ lib, config, pkgs, ... }:

let
  cfg = config.profiles.services.core;
in
{
  options.profiles.services.core = {
    enable = lib.mkEnableOption "Core services (X11, audio, printing, flatpak, ssh, docker)";
  };

  config = lib.mkIf cfg.enable {
    ############################################################################
    ## X11 / keyboard
    ############################################################################
    services.xserver = {
      enable = true;

      xkb = {
        layout = "us,ru";
        options = "grp:alt_shift_toggle";
        variant = "";
      };
    };

    ############################################################################
    ## Printing
    ############################################################################
    services.printing.enable = true;

    ############################################################################
    ## Audio (PipeWire)
    ############################################################################
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    ############################################################################
    ## Flatpak
    ############################################################################
    services.flatpak.enable = true;

    systemd.services.flatpak-repo = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.flatpak ];
      script = ''
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        flatpak install -y flathub ru.yandex.Browser
      '';
    };

    ############################################################################
    ## OpenSSH
    ############################################################################
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        X11Forwarding = false;
        AllowTcpForwarding = "yes";
      };
    };

    ############################################################################
    ## Docker
    ############################################################################
    virtualisation.docker.enable = true;
  };
}

