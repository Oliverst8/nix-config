{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  kittie = pkgs.callPackage ./kitty-cli.nix { };
in
{

  config = mkIf config.kitty-cli.enable {
    environment.systemPackages = [ kittie ];
  };
}
