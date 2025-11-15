{ lib, config, pkgs, inputs, ... }:

let
  cfg = config.profiles.services.xremap;
in
{
  imports = [
    inputs.xremap.nixosModules.default
  ];

  options.profiles.services.xremap = {
    enable = lib.mkEnableOption "xremap key remapper (Win+S -> ghostty)";
  };

  config = lib.mkIf cfg.enable {
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
  };
}

