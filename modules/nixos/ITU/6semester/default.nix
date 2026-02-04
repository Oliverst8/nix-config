{ pkgs, ... }:

{

  environment.systemPackages = [
    pkgs.uv
    pkgs.jetbrains.idea
    pkgs.android-studio-full
    pkgs.gradle
    pkgs.cudaPackages.cuda_nvcc
    pkgs.cudaPackages.cudatoolkit
  ];

  nixpkgs.config.android_sdk.accept_license = true;

}
