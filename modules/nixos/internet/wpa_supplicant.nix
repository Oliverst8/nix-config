{ ... }:
let
       pkgs = import (builtins.fetchGit {
           # Descriptive name to make the store path easier to identify
    #name = "wpa_supplicant_2.10";
           name = "wpa_supplicant_2.9";
           url = "https://github.com/NixOS/nixpkgs/";
           ref = "refs/heads/nixos-24.05";
    #rev = "270dace49bc95a7f88ad187969179ff0d2ba20ed";
           rev = "0229135d7a2eedc5490cafb8c61562f71c6d357b";
       }) {
        system = "x86_64-linux";  # Specify your system architecture here
    };

  #    pkgs = import (builtins.fetchTarball {
  #        name = "wpa_supplicant_2.10";
  #        url = "https://github.com/NixOS/nixpkgs/archive/270dace49bc95a7f88ad187969179ff0d2ba20ed.tar.gz";
  #        sha256 = "1qccp1vafcy3s95mix4pynw12i340fqfn498vir7ng1p1vl1zsiw";
  #    }) {};


     myPkg = pkgs.wpa_supplicant;
in {
  environment.systemPackages = [
    myPkg
  ];
}



