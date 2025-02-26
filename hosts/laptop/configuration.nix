# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./options.nix

    ../../modules/nixos/common
  ];

  config = {

    desktop.environment = "hyprland"; # Pick between kde or hyprland

    services.gottis.enable = true;

    #networking.eduroamPatch.enable = true; # Enable being able to connect to the wifi at ITU

    home-manager = {
      # also pass inputs to home-manager modules
      extraSpecialArgs = { inherit inputs; };
      users = {
        "ostarup" = import ./home.nix;
      };
    };
  };
}
