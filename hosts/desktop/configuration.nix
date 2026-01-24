# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  inputs,
  lib,
  sources,
  ...
}:

{

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./options.nix

    ../../modules/nixos/common
    ../../pkgs/wiseflow
  ];

  config = {

    boot.loader = {
      timeout = 1;
      grub.extraConfig = ''
        #Initialize network
        insmod efinet
        insmod http
        net_dhcp

        #set default option
        set default=2

        source (http,192.168.50.68:3141)/bootMenuChoice
      '';
    };

    desktop.environment = "hyprland"; # Pick between kde or hyprland
    networking.hostName = "desktop"; # Define your hostname.

    #networking.eduroamPatch.enable = true; # Enable being able to connect to the wifi at ITU

    home-manager = {
      # also pass inputs to home-manager modules
      extraSpecialArgs = { inherit inputs sources; };
      users = {
        "ostarup" = import ./home.nix;
      };
    };
    #Nixos build in options
    networking.interfaces.enp12s0.wakeOnLan.enable = true;

  };
}
