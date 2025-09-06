{ pkgs, ... }:

let
  ohMyTmux = pkgs.fetchFromGitHub {
    owner = "gpakosz";
    repo = ".tmux";
    rev = "master"; # or "master" if you want latest
    sha256 = "sha256-hash-here"; # run `nix-prefetch-git` or `nix-prefetch-url` to get this
  };
in
{
  programs.tmux.enable = true;

  home.file.".tmux.conf".source = "${ohMyTmux}/.tmux.conf";
  home.file.".tmux.conf.local".source = ./tmux.conf.local; # your own overrides
}
