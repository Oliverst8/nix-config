{ pkgs, ... }:

{

  environment.systemPackages = [
    pkgs.uv
    pkgs.jetbrains.idea
    pkgs.android-studio-full
    pkgs.gradle
  ];

  nixpkgs.config.android_sdk.accept_license = true;

}
