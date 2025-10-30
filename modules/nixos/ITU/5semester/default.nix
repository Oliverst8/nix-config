{ pkgs, ... }:

{

  environment.systemPackages = [
    pkgs.mosh
    pkgs.ddd
    pkgs.valgrind
    pkgs.protoc-gen-go-grpc
    pkgs.protoc-gen-go
    pkgs.protobuf
    pkgs.jetbrains.clion
  ];

}
