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
