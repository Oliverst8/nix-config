{ pkgs, sources }:

pkgs.tmuxPlugins.mkTmuxPlugin {
  pluginName = "named-snapshot.tmux";
  rtpFilePath = "named-snapshot.tmux";
  version = "v1"; # or the latest release
  src = sources.tmux-named-snapshot;
}
