{ pkgs }:

pkgs.tmuxPlugins.mkTmuxPlugin {
  pluginName = "named-snapshot.tmux";
  rtpFilePath = "named-snapshot.tmux";
  version = "v1"; # or the latest release
  src = pkgs.fetchFromGitHub {
    owner = "spywhere";
    repo = "tmux-named-snapshot";
    rev = "main"; # replace with the tag or commit you want
    sha256 = "sha256-EW1X+ZVl+hIIqAsj+bv6dkjQtNiBEhUYOQK/8bFEpV8=";
  };
}
