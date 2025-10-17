{
  config,
  lib,
  pkgs,
  sources,
  ...
}:

with lib;

let
  gottis = pkgs.callPackage ./gottis.nix { inherit sources; };
in
{
  #options.services.gottis = {
  #enable = mkEnableOption "Gottis system info TUI";
  #};

  config = mkIf config.gottis.enable {
    environment.systemPackages = [ gottis ];
  };
}
