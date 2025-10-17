{ pkgs, sources }:

pkgs.tmuxPlugins.mkTmuxPlugin {
  pluginName = "tmux-tokyo-night.tmux";
  rtpFilePath = "tmux-tokyo-night.tmux";
  version = "v1.11.0"; # or the latest release
  src = sources.tmux-tokyo-night;
}
