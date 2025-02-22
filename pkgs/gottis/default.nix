{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  gottis = pkgs.callPackage ./gottis.nix { };
in
{
  options.services.gottis = {
    enable = mkEnableOption "Gottis system info TUI";
  };

  config = mkIf config.services.gottis.enable {
    environment.systemPackages = [ gottis ];
  };
}
