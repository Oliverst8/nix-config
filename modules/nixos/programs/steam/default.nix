{
  pkgs,
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.steam.enable {
    programs.steam.enable = true;
  };
}
