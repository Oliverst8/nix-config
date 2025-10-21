{
  config,
  lib,
  pkgs,
  sources,
  ...
}:

let
  librepods = pkgs.callPackage ./librepods.nix { inherit sources; };
in
{

  config = {
    environment.systemPackages = [ librepods ];
  };
}
