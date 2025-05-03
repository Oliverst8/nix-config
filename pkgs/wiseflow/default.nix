let
  pkgs = import <nixpkgs> { };
  std = pkgs.stdenv;
in
rec {
  wiseflow-device-monitor-source = std.mkDerivation {
    name = "wiseflow-device-monitor-source";
    src = ./wiseflow_device_monitor_2.4.3_linux.deb;

    nativeBuildInputs = [ pkgs.dpkg ];

    unpackPhase = ''
      dpkg-deb --fsys-tarfile $src | tar -x --no-same-owner
      mv usr $out
    '';
  };

  wiseflow-device-monitor = pkgs.buildFHSEnv {
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
}
