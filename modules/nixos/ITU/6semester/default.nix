{ pkgs, ... }:

{

  environment.systemPackages = [
    pkgs.uv
    pkgs.cudaPackages.cuda_nvcc
    pkgs.cudaPackages.cudatoolkit
  ];

}
