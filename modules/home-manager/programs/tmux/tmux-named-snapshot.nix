{ pkgs }:

pkgs.tmuxPlugins.mkTmuxPlugin {
  pluginname = "tmux-named-snapshot.tmux";
  rtpfilepath = "tmux-named-snapshot.tmux";
  version = "v1"; # or the latest release
  src = pkgs.fetchfromgithub {
    owner = "spywhere";
    repo = "tmux-named-snapshot";
    rev = "main"; # replace with the tag or commit you want
    sha256 = "sha256-wjdbunwmxbw/jjvc34ujowif18poc3wvo1s+hk9slg4=";
  };
}
