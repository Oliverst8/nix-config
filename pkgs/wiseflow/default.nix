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
    src = ./wiseflow_device_monitor_2.7.0_linux.deb;
    nativeBuildInputs = [ pkgs.dpkg ];
    unpackPhase = ''
      dpkg-deb --fsys-tarfile $src | tar -x --no-same-owner
      mv usr $out
    '';
  };

  # gnome-screenshot fails on non-GNOME Wayland, so fake it there with a native tool
  screenshot-shim = pkgs.writeShellScriptBin "gnome-screenshot" ''
    [ -n "$WAYLAND_DISPLAY" ] || exec ${old.gnome-screenshot}/bin/gnome-screenshot "$@"
    file=
    while [ $# -gt 0 ]; do
      case "$1" in
        -f | --file) file="$2"; shift ;;
        --file=*) file="''${1#--file=}" ;;
      esac
      shift
    done
    [ -n "$file" ] || exit 1
    case "$XDG_CURRENT_DESKTOP" in
      *KDE*) exec ${pkgs.kdePackages.spectacle}/bin/spectacle -b -n -f -p -o "$file" ;;
      *) exec ${pkgs.grim}/bin/grim -c -t png "$file" ;;
    esac
  '';

  # Use oldPkgs.webkitgtk_4_0 from the pinned 25.05 set
  wiseflow-device-monitor = pkgs.buildFHSEnv {
    name = "wiseflow-device-monitor";
    targetPkgs = pkgs: [
      old.gtk3
      screenshot-shim
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
    # JSC_SIGNAL_FOR_GC=12 is what 2.7.0's own desktop entry sets
    # LD_LIBRARY_PATH is dropped because browsers leak host libs into it
    # GDK_BACKEND=x11 so the app sees its own window, else process uploads get a 400
    runScript = ''
      env -u LD_LIBRARY_PATH LIBGL_ALWAYS_SOFTWARE=1 GDK_BACKEND=x11 JSC_SIGNAL_FOR_GC=12 ${wiseflow-device-monitor-source}/bin/wiseflow-device-monitor "$@"
    '';
    extraInstallCommands = ''
      install -Dm644 ${wiseflow-device-monitor-source}/share/pixmaps/wiseflow-device-monitor.png \
        $out/share/pixmaps/wiseflow-device-monitor.png
      install -Dm644 ${wiseflow-device-monitor-source}/share/applications/wiseflow-device-monitor.desktop \
        $out/share/applications/wiseflow-device-monitor.desktop
      substituteInPlace $out/share/applications/wiseflow-device-monitor.desktop \
        --replace-fail "Exec=env JSC_SIGNAL_FOR_GC=12 wiseflow-device-monitor" "Exec=wiseflow-device-monitor"
    '';
  };
in
{
  config = lib.mkIf config.itu.wiseflow.enable {
    environment.systemPackages = [
      wiseflow-device-monitor
    ];
    xdg.mime.defaultApplications."x-scheme-handler/wfdm" = "wiseflow-device-monitor.desktop";

    # X11 session for exams, since the monitor is built for X11
    services.xserver.enable = true;
    services.xserver.desktopManager.xfce.enable = true;
    # Clashes with dunst over org.freedesktop.Notifications
    environment.xfce.excludePackages = [ pkgs.xfce4-notifyd ];
  };
}
