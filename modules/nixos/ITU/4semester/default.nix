{pkgs, ...}:

{
environment.systemPackages = [
    pkgs.jetbrains.rider
    pkgs.dotnet-sdk_7
  ];
}
