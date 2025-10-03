{
  description = "Pinned Git sources for my config";

  inputs = {
    # Pin repo and branch
    kitty-src = {
      url = "github:oliverst8/kittie/feat/contest";
      flake = false; # repo isn't a flake
    };
    plymouth-macos-theme-src = {
      url = "github:oliverst8/MacOS-sus-Boot-Plymouth";
      flake = false;
    };
  };

  outputs =
    {
      self,
      kitty-src,
      plymouth-macos-theme-src,
    }:
    {
      sources = {
        kitty = kitty-src;
        plymouth-macos-theme = plymouth-macos-theme-src;
      };
    };
}
