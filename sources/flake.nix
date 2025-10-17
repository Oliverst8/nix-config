{
  description = "Pinned Git sources";

  inputs = {
    kitty-src = {
      url = "github:oliverst8/kittie/feat/contest";
      flake = false;
    };
    plymouth-macos-theme-src = {
      url = "github:oliverst8/MacOS-sus-Boot-Plymouth";
      flake = false;
    };
    gottis-src = {
      url = "github:oliverst8/gottis";
      flake = false;
    };
    tmux-tokyo-night-src = {
      url = "github:fabioluciano/tmux-tokyo-night";
      flake = false;
    };
    tmux-named-snapshot-src = {
      url = "github:spywhere/tmux-named-snapshot";
      flake = false;
    };

  };

  outputs = inputs: {
    sources = {
      kitty = inputs.kitty-src;
      plymouth-macos-theme = inputs.plymouth-macos-theme-src;
      gottis = inputs.gottis-src;
      tmux-tokyo-night = inputs.tmux-tokyo-night-src;
      tmux-named-snapshot = inputs.tmux-named-snapshot-src;
    };
  };
}
