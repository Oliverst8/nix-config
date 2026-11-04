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
    nixos-package-search-src = {
      url = "github:oliverst8/nixos-package-search";
      flake = false;
    };
    claude-usage-waybar-src = {
      url = "github:infiniV/claude-usage-waybar";
      flake = false;
    };
    # Bump the tag and pkgs/azure-functions-core-tools/deps.json together.
    azure-functions-core-tools-src = {
      url = "github:Azure/azure-functions-core-tools/4.15.1";
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
      azure-functions-core-tools = inputs.azure-functions-core-tools-src;
      nixos-package-search = inputs.nixos-package-search-src;
      claude-usage-waybar = inputs.claude-usage-waybar-src;
    };
  };
}
