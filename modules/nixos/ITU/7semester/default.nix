{ pkgs, ... }:

{

  environment.systemPackages = [
    pkgs.scala-cli
    pkgs.conda
  ];
}
