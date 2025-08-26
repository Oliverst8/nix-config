{ pkgs, ... }:

{

  environment.systemPackages = [
    pkgs.mosh
    pkgs.ddd
  ];

}
