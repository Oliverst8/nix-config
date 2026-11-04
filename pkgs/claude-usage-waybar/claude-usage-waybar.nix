{
  lib,
  stdenvNoCC,
  pkgs,
  sources,
  ...
}:

let
  pythonEnv = pkgs.python3.withPackages (ps: [ ps.pygobject3 ]);

  runtimeDeps = with pkgs; [
    jq
    ccusage
    coreutils
    libnotify
    which
  ];

  # The popup dlopens this before libwayland so it anchors under the bar.
  layerShell = "${pkgs.gtk4-layer-shell}/lib/libgtk4-layer-shell.so.0";
in
stdenvNoCC.mkDerivation {
  pname = "claude-usage-waybar";
  version = "0-unstable-2026-11-04";

  src = sources.claude-usage-waybar;

  nativeBuildInputs = [
    pythonEnv
    pkgs.makeWrapper
    pkgs.wrapGAppsHook4
    pkgs.gobject-introspection
  ];

  buildInputs = [
    pkgs.gtk4
    pkgs.libadwaita
    pkgs.gtk4-layer-shell
  ];

  # Only the popup is a GTK app; the rest get a plain wrapper.
  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/claude-usage-waybar
    install -m755 -t $out/bin \
      bin/claude-usage-bar \
      bin/claude-usage-popup \
      bin/claude-usage-statusline \
      bin/claude-usage-today
    # Library imported via sys.path of the script's own directory.
    install -m644 -t $out/bin bin/claude_usage.py
    install -m644 -t $out/share/claude-usage-waybar \
      share/config/config.toml.example \
      share/waybar/style.css

    patchShebangs $out/bin

    runHook postInstall
  '';

  postFixup = ''
    for script in claude-usage-bar claude-usage-statusline claude-usage-today; do
      wrapProgram $out/bin/$script \
        --prefix PATH : ${lib.makeBinPath runtimeDeps}
    done

    # Pre-set the preload the popup would otherwise hunt for under /usr/lib.
    wrapProgram $out/bin/claude-usage-popup \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : ${lib.makeBinPath runtimeDeps} \
      --set LD_PRELOAD ${layerShell} \
      --set _CLAUDE_USAGE_POPUP_PRELOADED 1
  '';

  meta = {
    description = "Waybar module showing Claude Code rate limits, tokens and spend";
    homepage = "https://github.com/infiniV/claude-usage-waybar";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
