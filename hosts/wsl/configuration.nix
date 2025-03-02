# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:

{

  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
    ./options.nix

    ../../modules/nixos/common
  ];

  wsl.enable = true;
  wsl.defaultUser = "ostarup";


    #networking.eduroamPatch.enable = true; # Enable being able to connect to the wifi at ITU

    home-manager = {
      # also pass inputs to home-manager modules
      extraSpecialArgs = { inherit inputs; };
      users = {
        "ostarup" = import ./home.nix;
      };
  };
}
