{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = {
    environment.systemPackages =
      if lib.mkIf config.git.enable then
        [ pkgs.git ]
        + (if lib.mkIf config.lazygit.enable then [ pkgs.lazygit ] else [ ])
        + (if lib.mkIf config.gh.enable then [ pkgs.gh ] else [ ])
      else
        [ ];
  };
}
