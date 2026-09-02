{ pkgs, ... }:

{

  environment.systemPackages = [
    pkgs.scala-cli
    pkgs.conda
    pkgs.erlang_27
    pkgs.rebar3
  ];
}
