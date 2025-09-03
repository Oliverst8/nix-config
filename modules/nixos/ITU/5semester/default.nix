{ pkgs, ... }:

{

  environment.systemPackages = [
    pkgs.mosh
    pkgs.ddd
    pkgs.valgrind
  ];

}
