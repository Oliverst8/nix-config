# In your configuration.nix or in a separate module file
{ config, pkgs, ... }:

let
  wiseflow-device-monitor-source = pkgs.stdenv.mkDerivation {
    name = "wiseflow-device-monitor-source";
    src = ./wiseflow_device_monitor_2.4.3_linux.deb; # Path to your .deb file
    nativeBuildInputs = [ pkgs.dpkg ];
    unpackPhase = ''
      dpkg-deb --fsys-tarfile $src | tar -x --no-same-owner
      mv usr $out
    '';
  };

  wiseflow-device-monitor = pkgs.buildFHSEnv {
    # Note: buildFHSUserEnv instead of buildFHSEnv
    name = "wiseflow-device-monitor";
    targetPkgs = pkgs: [
      pkgs.gtk3
      pkgs.gnome-screenshot
      pkgs.xorg.xwininfo
      pkgs.glibc
      pkgs.glib
      pkgs.freetype
      pkgs.fontconfig
      pkgs.alsa-lib
      pkgs.libxkbcommon
      pkgs.gtk3
      pkgs.webkitgtk
      pkgs.gdk-pixbuf
      pkgs.xorg.libX11
      pkgs.xorg.libXext
      pkgs.xorg.libXrender
      pkgs.xorg.libXtst
      pkgs.xorg.libXi
    ];
    runScript = "${wiseflow-device-monitor-source}/bin/wiseflow-device-monitor";
  };
in
{
  # Add the package to your system packages
  environment.systemPackages = [
    wiseflow-device-monitor
  ];

}
