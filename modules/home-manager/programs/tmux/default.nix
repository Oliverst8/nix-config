{ pkgs, ... }:

let
  ohMyTmux = pkgs.fetchFromGitHub {
    owner = "gpakosz";
    repo = ".tmux";
    rev = "master"; # or "master" if you want latest
    sha256 = "0nzcfi7413mzh0ka59199h71ky6nrvgfy3aj8dhddbpb5cyv4y2x"; # run `nix-prefetch-git` or `nix-prefetch-url` to get this
  };
in
{
  programs.tmux.enable = true;

  home.file.".tmux.conf".source = "${ohMyTmux}/.tmux.conf";
  home.file.".tmux.conf.local".source = ./tmux.conf.local; # your own overrides
}
