{ pkgs, ... }:

{

  environment.systemPackages = [
    pkgs.uv
  ];

}
