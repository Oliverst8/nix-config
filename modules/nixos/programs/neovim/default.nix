{ inputs, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    #Neovim plugin and extra things needed for it
    neovim
    gcc
    gnumake42
    ripgrep
    xsel
    fd
    git
    lua
    cargo
    go
  ];
}
