{ pkgs, ... }:

{

  environment.systemPackages = [
    pkgs.scala-cli
    pkgs.conda
    pkgs.erlang-language-platform
  ];
}
