{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = {
    environment.systemPackages = lib.mkIf config.git.enable (
      [ pkgs.git ]
      ++ lib.optional config.git.lazygit.enable pkgs.lazygit
      ++ lib.optional config.git.gh.enable pkgs.gh
    );
  };
}
