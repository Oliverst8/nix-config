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

  };

  outputs = inputs: {
    sources = {
      kitty = inputs.kitty-src;
      plymouth-macos-theme = inputs.plymouth-macos-theme-src;
      gottis = inputs.gottis-src;
    };
  };
}
