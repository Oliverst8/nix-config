{ pkgs }:

pkgs.tmuxPlugins.mkTmuxPlugin {
  pluginName = "tmux-tokyo-night.tmux";
  rtpFilePath = "tmux-tokyo-night.tmux";
  version = "v1.11.0"; # or the latest release
  src = pkgs.fetchFromGitHub {
    owner = "fabioluciano";
    repo = "tmux-tokyo-night";
    rev = "v1.11.0"; # replace with the tag or commit you want
    sha256 = "sha256-WjDbunWmxbw/jjvc34ujOWif18POC3WVO1s+hk9SLg4=";
  };
}
