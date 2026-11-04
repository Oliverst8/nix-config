{
  config,
  lib,
  pkgs,
  sources,
  ...
}:

let
  claude-usage-waybar = pkgs.callPackage ./claude-usage-waybar.nix { inherit sources; };
in
{

  config = lib.mkIf config.claude-usage-waybar.enable {
    environment.systemPackages = [ claude-usage-waybar ];
  };
}
