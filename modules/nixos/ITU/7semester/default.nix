{ pkgs, ... }:

{

  environment.systemPackages = [
    pkgs.scala-cli
    pkgs.conda
    pkgs.beam27Packages.erlang
    pkgs.rebar3
  ];
}
