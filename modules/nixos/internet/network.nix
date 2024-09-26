{pkgs, ...}:
{
  # Enable networking
  networking.networkmanager.enable = true;

    # Overlay to pin NetworkManager to the nixos-24.05 channel
  nixpkgs.overlays = [
    (self: super: {
     wpa_supplicant = (import (builtins.fetchGit {
        name = "Network_manager_with_2_9_wpa_supplicant";
        url = "https://github.com/NixOS/nixpkgs/";
        ref = "refs/heads/nixos-24.05";
        rev = "0229135d7a2eedc5490cafb8c61562f71c6d357b"; #Wpa version 2.9
        #rev = "270dace49bc95a7f88ad187969179ff0d2ba20ed"; #wpa version 2.10
      }) {
        system = "x86_64-linux";  # Specify your system architecture here
        }).wpa_supplicant;

    })
  ];

  #          nixpkgs.config.packageOverrides = pkgs: rec {
  #          networking.networkmanager = pkgs.networkmanager.overrideAttrs (attrs: {
  #	    src = builtins.fetchGit {
  #           # Descriptive name to make the store path easier to identify
  #    #name = "wpa_supplicant_2.10";
  #           name = "wpa_supplicant_2.9";
  #           url = "https://github.com/NixOS/nixpkgs/";
  #           ref = "refs/heads/nixos-24.05";
  #    #rev = "270dace49bc95a7f88ad187969179ff0d2ba20ed";
  #           rev = "270dace49bc95a7f88ad187969179ff0d2ba20ed";
  #       };
  #          });
  #        };
  #
}
