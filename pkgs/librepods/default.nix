{
  config,
  lib,
  pkgs,
  sources,
  ...
}:

let
  librepods = pkgs.callPackage ./librepods.nix { inherit sources; };
in
{

  config = {
    environment.systemPackages = [ librepods ];
    systemd.user.services.librepods = {
      description = "LibrePods - AirPods support for Linux";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${librepods}/bin/librepods";
        Restart = "on-failure";
      };
    };
  };
}
