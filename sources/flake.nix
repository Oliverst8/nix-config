{
  description = "Pinned Git sources for my config";

  inputs = {
    # Pin repo and branch
    kitty-src = {
      url = "github:oliverst8/kittie/feat/contest";
      flake = false; # repo isn't a flake
    };
  };

  outputs =
    { self, kitty-src }:
    {
      sources = {
        kitty = kitty-src;
      };
    };
}
