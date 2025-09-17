{
  pkgs,
  config,
  lib,
  ...
}:
{
  environment.systemPackages = lib.mkIf config.discord.enable [ pkgs.discord ];
}
