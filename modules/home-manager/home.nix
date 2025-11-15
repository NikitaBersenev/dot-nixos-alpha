{ config, pkgs, ... }:

{
  home.username     = "habe";
  home.homeDirectory = "/home/habe";
  home.stateVersion = "24.11";

  home.packages = [ ];

  home.file = { };

  home.sessionVariables = { };

  programs.home-manager.enable = true;
}

