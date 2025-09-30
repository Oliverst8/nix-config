{ pkgs, ... }:

{

  environment.systemPackages = [
    pkgs.mosh
    pkgs.ddd
    pkgs.valgrind
    pkgs.protoc-gen-go-grpc
  ];

}
