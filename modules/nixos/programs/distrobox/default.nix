{
  pkgs,
  config,
  lib,
  ...
}:

{
  config = {
    environment.systemPackages = lib.mkIf config.discord.enable [ pkgs.distrobox ];
  };
}
