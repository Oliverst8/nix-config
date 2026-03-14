{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = {
    environment.systemPackages = lib.mkIf config.steam.enable [ pkgs.steam ];
  };
}
