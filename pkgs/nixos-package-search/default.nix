{
  config,
  lib,
  pkgs,
  sources,
  ...
}:

let
  nixos-package-search = pkgs.callPackage ./nixos-package-search.nix { inherit sources; };
in
{

  config = lib.mkIf config.nixos-package-search.enable {
    environment.systemPackages = [ nixos-package-search ];
  };
}
