{
  config,
  lib,
  pkgs,
  sources,
  ...
}:

with lib;

let
  kittie = pkgs.callPackage ./kitty-cli.nix { inherit sources; };
in
{

  config = mkIf config.kitty-cli.enable {
    environment.systemPackages = [ kittie ];
  };
}
