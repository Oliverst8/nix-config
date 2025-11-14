{
  config,
  pkgs,
  lib,
  old,
  ...
}:

let

  wiseflow-device-monitor-source = pkgs.stdenv.mkDerivation {
    name = "wiseflow-device-monitor-source";
    src = ./wiseflow_device_monitor_2.5.0_linux.deb;
    nativeBuildInputs = [ pkgs.dpkg ];
    unpackPhase = ''
      dpkg-deb --fsys-tarfile $src | tar -x --no-same-owner
      mv usr $out
    '';
  };

  # Use oldPkgs.webkitgtk_4_0 from the pinned 25.05 set
  wiseflow-device-monitor = pkgs.buildFHSEnv {
    name = "wiseflow-device-monitor";
    targetPkgs = pkgs: [
      old.gtk3
      old.gnome-screenshot
      old.xorg.xwininfo
      old.glibc
      old.glib
      old.freetype
      old.fontconfig
      old.alsa-lib
      old.libxkbcommon
      old.webkitgtk_4_0
      old.gdk-pixbuf
      old.xorg.libX11
      old.xorg.libXext
      old.xorg.libXrender
      old.xorg.libXtst
      old.xorg.libXi
      old.mesa
      old.libgbm
      old.libglvnd
      old.libdrm
    ];
    runScript = ''
      env LIBGL_ALWAYS_SOFTWARE=1 ${wiseflow-device-monitor-source}/bin/wiseflow-device-monitor "$@"
    '';
  };
in
{
  config = lib.mkIf config.itu.wiseflow.enable {
    environment.systemPackages = [
      wiseflow-device-monitor
    ];
  };
}
