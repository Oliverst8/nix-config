{ pkgs, ... }:

{

  environment.systemPackages = [
    pkgs.uv
    pkgs.jetbrains.idea
    pkgs.android-studio
    pkgs.gradle
  ];

  nixpkgs.config.android_sdk.accept_license = true;

}
