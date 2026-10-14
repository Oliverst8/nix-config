{ inputs, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #Neovim plugin and extra things needed for it
    neovim
    gcc15
    gnumake42
    ripgrep
    xsel
    fd
    git
    lua
    go
  ];
}
