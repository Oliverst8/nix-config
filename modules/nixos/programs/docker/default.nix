{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.docker.enable {

    #Enable docker
    virtualisation.docker.enable = true;

    environment.systemPackages = [
      pkgs.docker
    ] ++ lib.optional config.docker.lazydocker.enable pkgs.lazydocker;
  };
}
